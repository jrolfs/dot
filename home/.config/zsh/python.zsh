# Fix Python SSL issue
# https://github.com/danhper/asdf-python/issues/106#issuecomment-873814320

local certificate_path=$(python -m certifi 2>/dev/null)

if [ -n "$certificate_path" ]; then
  export SSL_CERT_FILE=${certificate_path}
  export REQUESTS_CA_BUNDLE=${certificate_path}
fi
