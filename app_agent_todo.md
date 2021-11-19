## Vy-logik:
"Parent"
  Om Phobrary Server inställd & rättigheter finns kvar, visa skärm 3
  Om Phobrary Server inställd & rättigheter finns kvar, men phobrary inte nås, visa felskärm 4, länka skärm 1
  Om Phobrary Server inställd, men inga rättigheter, visa skärm 2
  - Skärm 1: Serverskärm
    - Info om Phobrary Server
    - Ställ in Phobrary Server på IP-adress
    - Spara server i "localstorage"
  - Skärm 2: Rättighetsskärm
    - Förklara varför vi behöver rättigheter att läsa
    - Fråga om rättigheter att läsa
    - Spara val i localstorage
  - Skärm 3: Synkroniseringsskärm
    - Reglage för mobildata/wifi
    - Reglage för pausa/återuppta synkronisering
    - Visa ut alla album som synkas i scrollview, markera procent klart på alla.
    - Visa ut total progress

## Tekniska krav:
- Sentry eller dylikt
- Läsa & lyssna på wifi-status
- Läsa & lyssna på Mobil-data-status
- Läsa & lyssna på airplane-mode-status
- Läsa album från Photos Framework
- Läsa antal bilder i varje album
- Kolla om "kamerarullen" är ett album
- Kolla om man kan filtrera alla album på bilder som inte finns i Album X, isåfall, skapa ett album specifikt för vår app.
- Läs ut bilddatan ur en bild i ett album.
- Göra en multi-trådad uppladdning av bilder

Kolla om det finns bibliotek för att göra rsync mellan ios och server


## Certs:
require 'webrick/https'
irb(main):085:0> cert, rsa = WEBrick::Utils.create_self_signed_cert 1024, [["CN", "localhost"]], ""
