{
  "progName": "ChartTable",
  "htmlText": "<a href='http://highcharttable.org/#demo' target=\"_blank\">See official demos on external website</a>\n<br/><br/>\n<table class=\"highchart\" data-graph-container-before=\"1\" data-graph-type=\"column\">\n  <thead>\n      <tr>\n          <th>Month</th>\n          <th>Sales</th>\n      </tr>\n   </thead>\n   <tbody>\n      <tr>\n          <td>January</td>\n          <td>8000</td>\n      </tr>\n      <tr>\n          <td>February</td>\n          <td>12000</td>\n      </tr>\n  </tbody>\n</table>",
  "scriptText": "$('table.highchart').highchartTable();\n\nAPI_LogMessage(\"This demo shows how to use HighchartTable plugin to convert html table to a graph.\"); "
}