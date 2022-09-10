// This file is generated by GoAdmin CLI adm.
package tables

import "github.com/GoAdminGroup/go-admin/plugins/admin/modules/table"

// The key of Generators is the prefix of table info url.
// The corresponding value is the Form and Table data.
//
// http://{{config.Domain}}:{{Port}}/{{config.Prefix}}/info/{{key}}
//
// example:
//
// "alerts" => http://localhost:9033/admin/info/alerts
// "server_reports" => http://localhost:9033/admin/info/server_reports
// "servers" => http://localhost:9033/admin/info/servers
// "users" => http://localhost:9033/admin/info/users
//
// example end
var Generators = map[string]table.Generator{

	"alerts":         GetAlertsTable,
	"server_reports": GetServerReportsTable,
	"servers":        GetServersTable,

	// generators end
}