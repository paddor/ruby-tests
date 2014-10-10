#! /usr/bin/env ruby

nummern = [
  "+41 ( 0 ) 79-123 4567",
  "+41-79-123 4567",
  "079 123 45 67",
  "+41 ( 079 ) 123 67 90",
]

# fuer jede nummer ...
nummern.each do |nr| # aktuelle nummer ist in variable "nr"

  # ersetze alle o (ignore case) mit 0
  nr.gsub! /o/i, "0"

  # loesche sowas wie "( 0 )"
  nr.sub! /\(\s*0\s*\)/, ""

  # mache "79" aus "( 079 )"
  nr.sub! /\(\s*0+(\d+)\s*\)/, '\1'

  # loesche alle nicht-Ziffern
  nr.gsub! /\D/, ""

  # loesche fuehrende Nullen
  nr.sub! /^0+/, ""

  # wenn Nummer Landesvorwahl enthaelt
  if nr.size > 9
    # mit fuehrendem "00" ausgeben
    puts "00" + nr

  # sonst
  else
    # mit fuehrendem "0" ausgeben
    puts "0" + nr
  end
end
