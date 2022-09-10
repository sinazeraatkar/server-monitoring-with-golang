package tables

import (
	"github.com/GoAdminGroup/go-admin/context"
	"github.com/GoAdminGroup/go-admin/modules/db"
	"github.com/GoAdminGroup/go-admin/plugins/admin/modules/table"
	"github.com/GoAdminGroup/go-admin/template/types/form"
)

func GetServersTable(ctx *context.Context) table.Table {

	servers := table.NewDefaultTable(table.DefaultConfigWithDriver("postgresql"))

	info := servers.GetInfo().HideFilterArea()

	info.AddField("Id", "id", db.Int4).FieldFilterable()
	info.AddField("User_id", "user_id", db.Int4)
	info.AddField("Name", "name", db.Varchar)
	info.AddField("Url", "url", db.Varchar)
	info.AddField("Address", "address", db.Varchar)
	info.AddField("Ping", "ping", db.Int4)
	info.AddField("Last_check", "last_check", db.Timestamp)
	info.AddField("Details", "details", db.Varchar)
	info.AddField("Status", "status", db.Varchar)
	info.AddField("Last_log", "last_log", db.Varchar)
	info.AddField("Last_err", "last_err", db.Varchar)
	info.AddField("Created_at", "created_at", db.Timestamp)

	info.SetTable("servers").SetTitle("Servers").SetDescription("Servers")

	formList := servers.GetForm()
	formList.AddField("Id", "id", db.Int4, form.Default).FieldNotAllowEdit().FieldNotAllowAdd()
	formList.AddField("User_id", "user_id", db.Int4, form.Number)
	formList.AddField("Name", "name", db.Varchar, form.Text)
	formList.AddField("Url", "url", db.Varchar, form.Text)
	formList.AddField("Address", "address", db.Varchar, form.Text)
	formList.AddField("Ping", "ping", db.Int4, form.Default).FieldNotAllowAdd()
	formList.AddField("Last_check", "last_check", db.Timestamp, form.Default).FieldNotAllowAdd()
	formList.AddField("Details", "details", db.Varchar, form.Text)
	formList.AddField("Status", "status", db.Varchar, form.Default).FieldNotAllowAdd()
	formList.AddField("Last_log", "last_log", db.Varchar, form.Default).FieldNotAllowAdd()
	formList.AddField("Last_err", "last_err", db.Varchar, form.Default).FieldNotAllowAdd()
	formList.AddField("Created_at", "created_at", db.Timestamp, form.Default).FieldNotAllowEdit().FieldNotAllowAdd()

	formList.SetTable("servers").SetTitle("Servers").SetDescription("Servers")

	return servers
}
