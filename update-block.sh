#!/bin/bash
f="app/design/frontend/Positivus/positivus/cms/$1.html"
python3 - "$f" "positivus-$1" <<'PY' > /tmp/block.sql
import sys, pathlib
t = pathlib.Path(sys.argv[1]).read_text().replace("\\", "\\\\").replace("'", "''")
print("UPDATE cms_block SET content='%s' WHERE identifier='%s';" % (t, sys.argv[2]))
PY
sudo mysql positivus_magento < /tmp/block.sql
(cd app/design/frontend/Positivus/positivus/web/tailwind && npm run build)
cp app/design/frontend/Positivus/positivus/web/css/styles.css pub/static/frontend/Positivus/positivus/en_US/css/styles.css
sudo rm -rf var/cache/* var/page_cache/*
echo "Готово: $1"
