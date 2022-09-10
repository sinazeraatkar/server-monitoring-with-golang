package pages

import (
	"fmt"
	"html/template"
	"os"
	"time"

	"github.com/GoAdminGroup/go-admin/context"
	tmpl "github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/chartjs"
	"github.com/GoAdminGroup/go-admin/template/types"
	"gopkg.in/ini.v1"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	DatabaseConnection *gorm.DB
	SystemConfig       = MainConfigStruct{}
	results            [5]server
	result             server

	chartData [4][100]server
	data      server

	first_chart_data      []float64
	second_chart_data     []float64
	third_chart_data      []float64
	forth_chart_data      []float64
	horizontal_chart_data []string
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

// GetContent return the content of index page.
func DashboardPage(ctx *context.Context) (types.Panel, error) {

	cfg, err := ini.Load("config.ini")

	if err != nil {
		fmt.Printf("Fail to read file: %v", err)
		os.Exit(1)
	}

	SystemConfig.DatabaseConfig.DatabaseUsername = cfg.Section("database").Key("db_username").String()
	SystemConfig.DatabaseConfig.DatabasePassword = cfg.Section("database").Key("db_password").String()
	SystemConfig.DatabaseConfig.DatabaseName = cfg.Section("database").Key("db_name").String()
	SystemConfig.HttpConfig.WebApiPort, _ = cfg.Section("system").Key("web_api_port").Int()

	DatabaseConnection, err = gorm.Open(postgres.Open(fmt.Sprintf("host=localhost port=5432 user=%s dbname=%s password=%s TimeZone=Asia/Tehran", SystemConfig.DatabaseConfig.DatabaseUsername, SystemConfig.DatabaseConfig.DatabaseName, SystemConfig.DatabaseConfig.DatabasePassword)), &gorm.Config{})

	if err != nil {
		panic(err)
	}
	components := tmpl.Default()
	colComp := components.Col()
	/**************************
	 * Box
	/**************************/

	row, err := DatabaseConnection.Raw("SELECT * FROM servers ORDER BY last_check LIMIT 5").Rows()

	if err == nil {
		for row.Next() {
			DatabaseConnection.ScanRows(row, &result)
			if result.Id != 0 {
				results[4] = results[3]
				results[3] = results[2]
				results[2] = results[1]
				results[1] = results[0]
				results[0] = result
			}
		}
	}
	defer row.Close()

	table := components.
		Table().SetType("table").SetInfoList([]map[string]types.InfoItem{
		{
			"Address":    {Content: template.HTML(fmt.Sprintf("%v", results[0].Address))},
			"Last Check": {Content: template.HTML(fmt.Sprintf("%v", results[0].LastCheck))},
			"Status":     {Content: template.HTML(fmt.Sprintf("%v", results[0].Status))},
			"Last Log":   {Content: template.HTML(fmt.Sprintf("%v", results[0].LastLog))},
			"Ping":       {Content: template.HTML(fmt.Sprintf("%v", results[0].Ping))},
		}, {
			"Address":    {Content: template.HTML(fmt.Sprintf("%v", results[1].Address))},
			"Last Check": {Content: template.HTML(fmt.Sprintf("%v", results[1].LastCheck))},
			"Status":     {Content: template.HTML(fmt.Sprintf("%v", results[1].Status))},
			"Last Log":   {Content: template.HTML(fmt.Sprintf("%v", results[1].LastLog))},
			"Ping":       {Content: template.HTML(fmt.Sprintf("%v", results[1].Ping))},
		}, {
			"Address":    {Content: template.HTML(fmt.Sprintf("%v", results[2].Address))},
			"Last Check": {Content: template.HTML(fmt.Sprintf("%v", results[2].LastCheck))},
			"Status":     {Content: template.HTML(fmt.Sprintf("%v", results[2].Status))},
			"Last Log":   {Content: template.HTML(fmt.Sprintf("%v", results[2].LastLog))},
			"Ping":       {Content: template.HTML(fmt.Sprintf("%v", results[2].Ping))},
		}, {
			"Address":    {Content: template.HTML(fmt.Sprintf("%v", results[3].Address))},
			"Last Check": {Content: template.HTML(fmt.Sprintf("%v", results[3].LastCheck))},
			"Status":     {Content: template.HTML(fmt.Sprintf("%v", results[3].Status))},
			"Last Log":   {Content: template.HTML(fmt.Sprintf("%v", results[3].LastLog))},
			"Ping":       {Content: template.HTML(fmt.Sprintf("%v", results[3].Ping))},
		}, {
			"Address":    {Content: template.HTML(fmt.Sprintf("%v", results[4].Address))},
			"Last Check": {Content: template.HTML(fmt.Sprintf("%v", results[4].LastCheck))},
			"Status":     {Content: template.HTML(fmt.Sprintf("%v", results[4].Status))},
			"Last Log":   {Content: template.HTML(fmt.Sprintf("%v", results[4].LastLog))},
			"Ping":       {Content: template.HTML(fmt.Sprintf("%v", results[4].Ping))},
		},
	}).SetThead(types.Thead{
		{Head: "Address"},
		{Head: "Status"},
		{Head: "Ping"},
		{Head: "Last Log"},
		{Head: "Last Check"},
	}).GetContent()

	boxInfo := components.Box().
		WithHeadBorder().
		SetHeader("Latest Checks").
		SetHeadColor("#e9fa32").
		SetBody(table).
		SetFooter(`<div class="clearfix"><a href="http://localhost:9033/admin/info/server_reports" class="btn btn-sm btn-info btn-flat pull-left">see server reports</a><a href="http://localhost:9033/admin/info/alerts" class="btn btn-sm btn-default btn-flat pull-right">alerts</a> </div>`).
		GetContent()

	row1 := colComp.SetSize(types.SizeMD(8)).SetContent(boxInfo).GetContent()

	/**************************
	 * Box
	/**************************/
	db_row, err2 := DatabaseConnection.Raw("SELECT address , ping ,last_check FROM servers ").Rows()
	j := 0
	if err2 == nil {
		for db_row.Next() {
			DatabaseConnection.ScanRows(db_row, &data)
			for j := 0; j < 4; j++ {
				if chartData[j][len(chartData[j])-1].Address == data.Address || chartData[j][len(chartData[j])-1].Address == "" {

					for i := 1; i < len(chartData[j]); i++ {
						chartData[j][i-1] = chartData[j][i]
					}
					chartData[j][len(chartData[j])-1] = data
					j = 4
				}
			}

		}
		//fmt.Println()
	}
	defer row.Close()

	for k := 0; k < len(chartData[0]); k++ {

		if len(first_chart_data) < len(chartData[0]) {
			first_chart_data = append(first_chart_data, float64(chartData[0][k].Ping))
		} else {

			first_chart_data = append(first_chart_data[1:], float64(chartData[0][k].Ping))

		}

		if len(second_chart_data) < len(chartData[0]) {
			second_chart_data = append(second_chart_data, float64(chartData[1][k].Ping))
		} else {

			second_chart_data = append(second_chart_data[1:], float64(chartData[1][k].Ping))

		}

		if len(third_chart_data) < len(chartData[0]) {
			third_chart_data = append(third_chart_data, float64(chartData[2][k].Ping))
		} else {

			third_chart_data = append(third_chart_data[1:], float64(chartData[2][k].Ping))

		}

		if len(forth_chart_data) < len(chartData[0]) {
			forth_chart_data = append(forth_chart_data, float64(chartData[3][k].Ping))
		} else {

			forth_chart_data = append(forth_chart_data[1:], float64(chartData[3][k].Ping))

		}

		if len(horizontal_chart_data) < len(chartData[0]) {
			horizontal_chart_data = append(horizontal_chart_data, fmt.Sprintf("%v:%v:%v", chartData[0][k].LastCheck.Hour(), chartData[0][k].LastCheck.Minute(), chartData[0][k].LastCheck.Second()))
		} else {

			horizontal_chart_data = append(horizontal_chart_data[1:], fmt.Sprintf("%v:%v:%v", chartData[0][k].LastCheck.Hour(), chartData[0][k].LastCheck.Minute(), chartData[0][k].LastCheck.Second()))

		}

	}
	first_chart_address := chartData[0][len(chartData[j])-1].Address
	second_chart_address := chartData[1][len(chartData[j])-1].Address
	third_chart_address := chartData[2][len(chartData[j])-1].Address
	forth_chart_address := chartData[3][len(chartData[j])-1].Address

	line := chartjs.Line()
	//fmt.Println(first_chart_address, second_chart_address, third_chart_address, forth_chart_address)
	lineChart := line.
		SetID("PINGCHART").
		SetHeight(350).
		SetTitle("PINGS: 5 minutes ago ").
		SetLabels(horizontal_chart_data).
		AddDataSet(first_chart_address).
		DSData(first_chart_data).
		DSFill(false).
		DSBorderColor("rgb(210, 214, 222,2)").
		DSLineTension(0.1).
		AddDataSet(second_chart_address).
		DSData(second_chart_data).
		DSFill(false).
		DSBorderColor("rgba(60,141,188,2)").
		DSLineTension(0.1).
		AddDataSet(third_chart_address).
		DSData(third_chart_data).
		DSFill(false).
		DSBorderColor("rgba(30,71,188,2)").
		DSLineTension(0.1).
		AddDataSet(forth_chart_address).
		DSData(forth_chart_data).
		DSFill(false).
		DSBorderColor("rgba(80,101,18,2)").
		DSLineTension(0.1).
		GetContent()

	boxInternalCol1 := colComp.SetContent(lineChart).SetSize(types.SizeMD(10)).GetContent()

	boxInternalRow := components.Row().SetContent(boxInternalCol1).GetContent()

	box := components.Box().WithHeadBorder().SetHeader("ping (ms) ").
		SetBody(boxInternalRow).
		GetContent()

	boxcol := colComp.SetContent(box).SetSize(types.SizeMD(12)).GetContent()
	row2 := components.Row().SetContent(boxcol).GetContent()

	/**************************
	 * Small Box
	/**************************/
	return types.Panel{
		Content:         row1 + row2,
		Title:           "Dashboard",
		Description:     "SERVER MONITORING DASHBOARD",
		AutoRefresh:     true,
		RefreshInterval: []int{10},
	}, nil
}
