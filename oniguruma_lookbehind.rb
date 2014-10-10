gaeste = <<LISTE
Mueller-Luedenscheidt, Gerda
Schmeichel-Geier, Heidelinde
Johanson, Paul-Egon
Huber-Geier, Elfriede
Geier, Hans-Hubert
Feuerpfeiffer, Gustav
LISTE

gaeste.scan(/^([^,]+)(?<!Geier),\s+(.+)$/) do |name, vorname|
#gaeste.scan(/^([^,]+),\s+(.+)$/) do |name, vorname|
#gaeste.scan(/^(?!Johanson)([^,]+),\s+(.+)$/) do |name, vorname|
  puts(vorname + ' ' + name)
end
