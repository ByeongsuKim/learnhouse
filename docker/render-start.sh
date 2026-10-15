#!/bin/sh
# Render.com entrypoint.
#
# Render routes public traffic to $PORT (set to 80 in render.yaml so it hits
# nginx), but the Next.js server inside the image also reads $PORT and must
# listen on 8000 where nginx proxies to. Domain-derived URLs default to the
# Render-assigned hostname; set LEARNHOUSE_DOMAIN to use a custom domain.

DOMAIN="${LEARNHOUSE_DOMAIN:-$RENDER_EXTERNAL_HOSTNAME}"
if [ -z "$DOMAIN" ]; then
    echo "LEARNHOUSE_DOMAIN or RENDER_EXTERNAL_HOSTNAME must be set" >&2
    exit 1
fi

export LEARNHOUSE_DOMAIN="$DOMAIN"
export NEXT_PUBLIC_LEARNHOUSE_DOMAIN="$DOMAIN"
export NEXT_PUBLIC_LEARNHOUSE_TOP_DOMAIN="${NEXT_PUBLIC_LEARNHOUSE_TOP_DOMAIN:-$DOMAIN}"
export NEXT_PUBLIC_LEARNHOUSE_API_URL="https://$DOMAIN/api/v1/"
export NEXT_PUBLIC_LEARNHOUSE_BACKEND_URL="https://$DOMAIN/"
export NEXT_PUBLIC_COLLAB_URL="wss://$DOMAIN/collab"
export NEXTAUTH_URL="https://$DOMAIN"

export PORT=8000

exec sh /app/start.sh
