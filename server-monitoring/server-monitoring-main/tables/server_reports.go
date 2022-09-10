package tables

import (
	"github.com/GoAdminGroup/go-admin/context"
	"github.com/GoAdminGroup/go-admin/modules/db"
	"github.com/GoAdminGroup/go-admin/plugins/admin/modules/table"
	"github.com/GoAdminGroup/go-admin/template/types/form"
)

func GetServerReportsTable(ctx *context.Context) table.Table {

	serverReports := table.NewDefaultTable(table.DefaultConfigWithDriver("postgresql"))
	info := serverReports.GetInfo().HideFilterArea()

	info.AddField("Id", "id", db.Int4).FieldFilterable()
	info.AddField("Server_id", "server_id", db.Int4)
	info.AddField("Last_status", "last_status", db.Varchar)
	info.AddField("Last_error", "last_error", db.Varchar)
	info.AddField("Created_at", "created_at", db.Timestamp)
	info.AddField("Ping", "ping", db.Int4)

	info.SetTable("server_reports").SetTitle("ServerReports").SetDescription("ServerReports")

	formList := serverReports.GetForm()
	formList.AddField("Id", "id", db.Int4, form.Default).FieldNotAllowEdit().FieldNotAllowAdd()
	formList.AddField("Server_id", "server_id", db.Int4, form.Number).FieldNotAllowAdd()
	formList.AddField("Last_status", "last_status", db.Varchar, form.Text).FieldNotAllowAdd()
	formList.AddField("Last_error", "last_error", db.Varchar, form.Text).FieldNotAllowAdd()
	formList.AddField("Created_at", "created_at", db.Timestamp, form.Datetime).FieldNotAllowAdd()
	formList.AddField("Ping", "ping", db.Int4, form.Default).FieldNotAllowAdd()

	formList.SetTable("server_reports").SetTitle("ServerReports").SetDescription("ServerReports")

	return serverReports
}
