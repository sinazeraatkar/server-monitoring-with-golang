package main

import (
	"context"

	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"time"

	"server-monitoring-main/pages"
	"server-monitoring-main/tables"

	"github.com/go-ini/ini"
	"github.com/go-ping/ping"
	"github.com/k0kubun/pp"
	"github.com/labstack/echo/v4"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"os/signal"

	_ "github.com/GoAdminGroup/go-admin/adapter/echo"
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/postgres"
	_ "github.com/GoAdminGroup/themes/adminlte"
	"gopkg.in/gomail.v2"

	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/chartjs"
)

var (
	Row                *sql.Rows
	DatabaseConnection *gorm.DB
	//H//ttpClient         = &http.Client{Timeout: time.Duration(60 * time.Second)}
	SystemConfig = MainConfigStruct{}
	From         = "sinazeraatkar@gmail.com"
	Password     = "oixonfhzrlsjshgg"
	SmtpHost     = "smtp.gmail.com" // smtp server configuration
	ping_err     error
	Err2         error
)

type DatabaseConfigStruct struct {
	DatabaseUsername string
	DatabasePassword string
	DatabaseName     string
}
type HttpConfigStruct struct {
	WebApiPort int
}
type MainConfigStruct struct {
	DatabaseConfig DatabaseConfigStruct
	HttpConfig     HttpConfigStruct
}

type server struct {
	Id        int       `json:"id"`
	Name      string    `json:"name"`
	UserId    int       `json:"user_id"`
	Details   string    `json:"details"`
	CreatedAt time.Time `json:"created_at"`
	Status    string    `json:"status"`
	LastCheck time.Time `json:"last_check"`
	Address   string    `json:"address"`
	Ping      int       `json:"ping"`
	LastLog   string    `json:"lastLog"`
	Url       string    `json:"url"`
	LastErr   string    `json:"last_err"`
}
type Alert struct {
	Id            int       `json:"id"`
	ServerId      int       `json:"server_id"`
	Address       string    `json:"address"`
	Url           string    `json:"url"`
	LastSendAt    time.Time `json:"last_send_at"`
	LastSendState string    `json:"last_send_state"`
	LastSendError string    `json:"last_send_error"`
}
type ServerReport struct {
	Id         int       `json:"id"`        //Id of the server report
	ServerId   int       `json:"server_id"` //Id of the server related to the server report
	LastStatus string    `json:"last_status"`
	LastError  string    `json:"last_error"` //
	CreatedAt  time.Time `json:"created_at"` //
	Ping       int       `json:"ping"`
}

func system_crons() {
	var Adrs string
	addrs := make(chan string, 20)
	ticker := time.NewTicker(2 * time.Second)
	done := make(chan bool)

	for {
		select {
		case <-done:
			return
		case <-ticker.C:
			Row, err := DatabaseConnection.Model(&server{}).Select("address").Rows()
			defer Row.Close()
			if err == nil {
				for Row.Next() {

					Row.Scan(&Adrs)

					addrs <- Adrs

				}

				go pinger(addrs)
			}

		}

	}
}
func load_config(file string) {

	cfg, err := ini.Load(file)

	if err != nil {
		fmt.Printf("Fail to read file: %v", err)
		os.Exit(1)
	}

	SystemConfig.DatabaseConfig.DatabaseUsername = cfg.Section("database").Key("db_username").String()
	SystemConfig.DatabaseConfig.DatabasePassword = cfg.Section("database").Key("db_password").String()
	SystemConfig.DatabaseConfig.DatabaseName = cfg.Section("database").Key("db_name").String()
	SystemConfig.HttpConfig.WebApiPort, _ = cfg.Section("system").Key("web_api_port").Int()
}
func start_system() {
	load_config("config.ini")
	DatabaseConnection, _ = gorm.Open(postgres.Open(fmt.Sprintf("host=localhost port=5432 user=%s dbname=%s password=%s TimeZone=Asia/Tehran", SystemConfig.DatabaseConfig.DatabaseUsername, SystemConfig.DatabaseConfig.DatabaseName, SystemConfig.DatabaseConfig.DatabasePassword)), &gorm.Config{})
	go system_crons()
}
func pinger(addrs <-chan string) {

	for i := range addrs {
		time.Sleep(2 * time.Second)
		var piing string
		pinger, Err := ping.NewPinger(i)
		var averagePing *time.Duration
		ping_err = Err
		// if err != nil {
		// 	panic(err)
		// }

		var UpdatedInfo server
		pinger.Count = 1
		pinger.Timeout = time.Second
		pinger.OnFinish = func(stats *ping.Statistics) {
			if stats.PacketsRecv == 0 {
				averagePing = nil
			} else {
				averagePing = &stats.AvgRtt
				piing = averagePing.String()

			}
		}

		Err2 = pinger.Run() // blocks until finished

		// if err2 != nil {
		// 	panic(err2)
		// }

		re, _ := regexp.Compile("([0-9]+)")
		match := re.FindString(piing)

		DatabaseConnection.First(&UpdatedInfo, "address = ?", i)
		intPing, _ := strconv.Atoi(match)
		UpdatedInfo.Ping = intPing

		UpdatedInfo.Handle()

		DatabaseConnection.Save(&UpdatedInfo)

		pinger.Stop()
	}

}

func (this *server) Handle() {
	var result ServerReport
	this.LastCheck = time.Now()
	this.LastErr = ""
	this.Status = "success"
	this.LastLog = "Connected at : " + time.Now().Format("2006-01-02 15:04:05")
	DatabaseConnection.Raw("SELECT ping,server_id,last_error FROM server_reports WHERE server_id = ? ORDER BY id DESC LIMIT 1", this.Id).Scan(&result)

	if ping_err != nil {
		this.LastErr = ping_err.Error()
		this.Status = "error"

		if ping_err.Error() != result.LastError {
			this.MakeError()
		}

		DatabaseConnection.Save(&this)
		this.AddReport()

		this.LastErr = ping_err.Error()

		return
	} else if this.Ping > 500 {
		this.LastErr = fmt.Sprintln("High ping error -->  ", this.Ping, "ms", " --> Check your internet connection")
		if result.Ping <= 500 {

			this.MakeError()
		}
		this.Status = "error"

		DatabaseConnection.Save(&this)
		this.AddReport()
		return
	} else {
		if Err2 != nil {
			this.LastErr = Err2.Error()
			this.Status = "error"

			if result.LastError != Err2.Error() {

				this.MakeError()
			}
			DatabaseConnection.Save(&this)
			this.AddReport()
			this.LastErr = Err2.Error()

			return
		}
	}

	DatabaseConnection.Save(&this)
	this.AddReport()
}

func (this *server) AddReport() {
	report_info := ServerReport{
		ServerId:   this.Id,
		LastStatus: this.Status,
		LastError:  this.LastErr,
		CreatedAt:  time.Now(),
		Ping:       this.Ping,
	}

	DatabaseConnection.Create(&report_info)
}

func (this *server) MakeError() {

	alret_infos := Alert{}

	// Receiver email address.
	log.SetFlags(log.Ldate)
	msg := this.Address + " is" + "Disconnected at : " + time.Now().Format("2006-01-02 15:04:05") + "\n" + "Error: " + this.LastErr
	this.LastLog = msg
	m := gomail.NewMessage()
	m.SetHeader("From", From)
	m.SetHeader("To", this.Url)
	m.SetHeader("Subject", "Server Error")
	m.SetBody("text/plain", this.LastLog)
	d := gomail.NewDialer(SmtpHost, 587, From, Password)

	// Send the email
	if err := d.DialAndSend(m); err == nil {
		alret_infos.ServerId = this.Id
		alret_infos.LastSendAt = time.Now()
		alret_infos.LastSendError = ""
		alret_infos.LastSendState = "success"
		DatabaseConnection.Save(&alret_infos)
	} else {
		alret_infos.ServerId = this.Id
		alret_infos.LastSendAt = time.Now()
		alret_infos.LastSendError = err.Error()
		alret_infos.LastSendState = "error"
		DatabaseConnection.Save(&alret_infos)
	}

	DatabaseConnection.Save(&this)

}

func main() {
	//sudo sysctl -w net.ipv4.ping_group_range="0   2147483647"

	pp.Println("start")
	start_system()

	e := echo.New()

	eng := engine.Default()
	template.AddComp(chartjs.NewChart())
	if err := eng.AddConfigFromJSON("./config.json").
		AddGenerators(tables.Generators).
		AddGenerator("server_reports", tables.GetServerReportsTable).
		Use(e); err != nil {
		panic(err)
	}

	e.Static("/uploads", "./uploads")

	eng.HTML("GET", "/admin", pages.DashboardPage)

	srv := &http.Server{
		Addr:    fmt.Sprintf(":%d", SystemConfig.HttpConfig.WebApiPort),
		Handler: e,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil {
			log.Printf("listen: %s\n", err)
		}
	}()

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server Shutdown:", err)
	}
	log.Println("Server exiting")

}