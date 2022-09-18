package tables

import (
	"github.com/GoAdminGroup/go-admin/context"
	"github.com/GoAdminGroup/go-admin/modules/db"
	"github.com/GoAdminGroup/go-admin/plugins/admin/modules/table"
	"github.com/GoAdminGroup/go-admin/template/types/form"
)

func GetAlertsTable(ctx *context.Context) table.Table {

	alerts := table.NewDefaultTable(table.DefaultConfigWithDriver("postgresql"))

	info := alerts.GetInfo().HideFilterArea()

	info.AddField("Id", "id", db.Int4).FieldFilterable()
	info.AddField("Server_id", "server_id", db.Int4)
	info.AddField("Address", "address", db.Varchar)
	info.AddField("Url", "url", db.Varchar)
	info.AddField("Last_send_at", "last_send_at", db.Timestamp)
	info.AddField("Last_send_state", "last_send_state", db.Varchar)
	info.AddField("Last_send_error", "last_send_error", db.Varchar)

	info.SetTable("alerts").SetTitle("Alerts").SetDescription("Alerts")

	formList := alerts.GetForm()
	formList.AddField("Id", "id", db.Int4, form.Default).FieldNotAllowAdd()
	formList.AddField("Server_id", "server_id", db.Int4, form.Number).FieldNotAllowAdd()
	formList.AddField("Address", "address", db.Varchar, form.Text).FieldNotAllowAdd()
	formList.AddField("Url", "url", db.Varchar, form.Text).FieldNotAllowAdd()
	formList.AddField("Last_send_at", "last_send_at", db.Timestamp, form.Datetime).FieldNotAllowAdd()
	formList.AddField("Last_send_state", "last_send_state", db.Varchar, form.Text).FieldNotAllowAdd()
	formList.AddField("Last_send_error", "last_send_error", db.Varchar, form.Text).FieldNotAllowAdd()

	formList.SetTable("alerts").SetTitle("Alerts").SetDescription("Alerts")

	return alerts
}
