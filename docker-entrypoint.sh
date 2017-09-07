#!/bin/bash
set -e 

SMTP_HOST=${SMTP_HOST:-localhost}
SMTP_PORT=${SMTP_PORT:-25}
SMTP_PROTOCOL=${MAIL_PROTOCOL:-smtp}
SMTP_AUTH=${SMTP_AUTH:-off}
SMTP_USERNAME=${SMTP_USERNAME:-}
SMTP_PASSWORD=${SMTP_PASSWORD:-}

SMTP_TLS=${SMTP_TLS:-off}
SMTP_STARTTLS=${SMPTP_STARTTLS_ENABLE:-off}
SMTP_TLS_CHECK=${SMTP_TLS_CHECK:-off}
SMTP_TLS_TRUST_FILE=${SMTP_TLS_TRUST_FILE:-}

MAIL_FROM_DEFAULT=${MAIL_FROM_DEFAULT:-limesurvey@example.com}
MAIL_TRUST_DOMAIN=${MAIL_TRUST_DOMAIN:-}
MAIL_DOMAIN=${MAIL_DOMAIN:-}
SMTP_TIMEOUT=${SMTP_TIMEOUT:-30000}
MAIL_SMTP_DEBUG=${MAIL_SMTP_DEBUG:-false}

PUBLIC_URL=${PUBLIC_URL:-}
# Write MSMTP configuration
cat > /etc/msmtprc << EOL
account default
host ${SMTP_HOST}
port ${SMTP_PORT}
protocol ${SMTP_PROTOCOL}
auth ${SMTP_AUTH}
user ${SMTP_USERNAME}
password ${SMTP_PASSWORD}
tls ${SMTP_TLS}
tls_starttls ${SMTP_STARTTLS}
tls_certcheck ${SMTP_TLS_CHECK}
tls_trust_file
from ${MAIL_FROM_DEFAULT}
maildomain ${MAIL_TRUST_DOMAIN}
domain ${MAIL_DOMAIN}
timeout ${SMTP_TIMEOUT}
EOL

# Write Public URL
if [ -z "$PUBLIC_URL" ];
    sed -i "s#\('debug'=>0,\)\$#\\1 'publicurl'=>'${PUBLIC_URL}',#g" application/config/config.php
fi

# Start Aphache
exec "$@"