# framework
import basolato/middleware
import basolato/routing
# self
from custom_headers_middleware import corsHeader


template framework*() =
  checkCsrfToken(request).catch()
  checkAuthToken(request).catch()
  if request.reqMethod == HttpOptions:
    route(render(""), [corsHeader()])
