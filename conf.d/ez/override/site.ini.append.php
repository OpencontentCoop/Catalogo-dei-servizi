<?php /* #?ini charset="utf-8"?

[ExpiryHandler]
ExpiryFilePerSiteAccess=enabled

[HTTPHeaderSettings]
ClientIpByCustomHTTPHeader=X-Forwarded-For
CustomHeader=enabled
OnlyForAnonymous=enabled
OnlyForContent=enabled
Cache-Control[]
Cache-Control[/]=public, must-revalidate, max-age=259200, s-maxage=7200

[SearchSettings]
LogSearchStats=disabled

[SiteSettings]
SiteName=Comune di Trento
SiteURL=servizipubblici.localtest.me
AdditionalLoginFormActionURL=http://servizipubblici.localtest.me/backend/user/login

[DatabaseSettings]
DatabaseImplementation=ezpostgresql
Server=postgres
Port=
User=openpa
Password=openp4ssword
Database=trentoservizipubblici
Charset=utf-8
Socket=disabled
SQLOutput=disabled

[FileSettings]
VarDir=var/trentoservizipubblici

[RoleSettings]
PolicyOmitList[]=user/login
PolicyOmitList[]=user/logout
PolicyOmitList[]=user/do_logout
PolicyOmitList[]=user/register
PolicyOmitList[]=user/activate
PolicyOmitList[]=user/success
PolicyOmitList[]=user/forgotpassword
PolicyOmitList[]=layout
PolicyOmitList[]=paypal/notify_url
PolicyOmitList[]=switchlanguage
PolicyOmitList[]=oauth/authorize
PolicyOmitList[]=odf/upload_import
PolicyOmitList[]=odf/authenticate
PolicyOmitList[]=odf/upload_export
PolicyOmitList[]=odf/ezodf_oo_client
PolicyOmitList[]=ezjscore/hello
PolicyOmitList[]=ezjscore/call
PolicyOmitList[]=openpa/classdefinition
PolicyOmitList[]=openpa/calendar
PolicyOmitList[]=openpa/object
PolicyOmitList[]=openpa/data
PolicyOmitList[]=robots.txt
PolicyOmitList[]=survey_user/verify
PolicyOmitList[]=comuneintasca/data
PolicyOmitList[]=openpa/signup
PolicyOmitList[]=openpa/cookie
PolicyOmitList[]=openpa/activate
PolicyOmitList[]=robots.txt
PolicyOmitList[]=survey_user/verify
PolicyOmitList[]=comuneintasca/data
PolicyOmitList[]=feed/rss
PolicyOmitList[]=feed/list
PolicyOmitList[]=exportas/csv
PolicyOmitList[]=exportas/xml
PolicyOmitList[]=exportas/custom
PolicyOmitList[]=sensor/alert
PolicyOmitList[]=ezinfo/is_alive
PolicyOmitList[]=flip/get
PolicyOmitList[]=nxc_captcha/get
PolicyOmitList[]=newsletter/configure
PolicyOmitList[]=newsletter/archive
PolicyOmitList[]=userpaex/password
PolicyOmitList[]=userpaex/forgotpassword
PolicyOmitList[]=opendata/api
PolicyOmitList[]=gdpr/acceptance
PolicyOmitList[]=gdpr/user_acceptance

[Session]
SessionNameHandler=custom
CookieHttponly=true
Handler=ezpSessionHandlerDB
ForceStart=disabled

[SiteSettings]
SiteList[]
SiteList[]=trentoservizipubblici_frontend
SiteList[]=trentoservizipubblici_backend

[UserSettings]
LogoutRedirect=/?logout
MinPasswordLength=8
#GeneratePasswordIfEmpty=false

[SiteAccessSettings]
ForceVirtualHost=true
DebugAccess=enabled
CheckValidity=false
MatchOrder=host_uri
RelatedSiteAccessList[]
RelatedSiteAccessList[]=trentoservizipubblici_frontend
RelatedSiteAccessList[]=trentoservizipubblici_backend
AvailableSiteAccessList[]
AvailableSiteAccessList[]=trentoservizipubblici_frontend
AvailableSiteAccessList[]=trentoservizipubblici_backend
HostUriMatchMapItems[]
HostUriMatchMapItems[]=servizipubblici.localtest.me;backend;trentoservizipubblici_backend
HostUriMatchMapItems[]=servizipubblici.localtest.me;;trentoservizipubblici_frontend

[MailSettings]
AdminEmail=no-reply@opencontent.it
EmailSender=no-reply@opencontent.it
TransportAlias[smtp]=OpenPASMTPTransport
Transport=smtp
TransportConnectionType=
TransportPort=1025
TransportServer=mailhog
TransportUser=
TransportPassword=

BlackListEmailDomains[]
BlackListEmailDomainSuffixes[]

[EmbedViewModeSettings]
AvailableViewModes[]=embed
AvailableViewModes[]=embed-inline
InlineViewModes[]=embed-inline

[TimeZoneSettings]
TimeZone=Europe/Rome

[RegionalSettings]
Locale=ita-IT
TextTranslation=enabled
TranslationExtensions[]=cjw_newsletter

[ContentSettings]
ContentObjectNameLimit=203
TranslationList=

[DebugSettings]
DebugToolbar=disabled

[UserFormToken]
CookieHttponly=true
CookieSecure=0

*/ ?>
