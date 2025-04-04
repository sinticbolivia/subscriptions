project('Subscriptions', 'vala', 'c',
  version: '1.0.1',
  default_options: [
    #'warning_level=1',
    'buildtype=debugoptimized'
  ],
)
vapi_dir = meson.current_source_dir()  + '/src/vapi'
SO_TARGET = get_option('so_target')
sbframework_dir = get_option('libsinticbolivia')

link_args = []
subsystem = false
#env = environment()
#env.append('PKG_CONFIG_PATH', '')
prj_args = [
  '--pkg', 'SinticBolivia',
  '--vapidir', sbframework_dir,
]
inc_directories = [
  '.',
  sbframework_dir,
]
# add libSinticBolivia library
# LIBSOUP
dsoup = dependency('libsoup-3.0', required: false)
if not dsoup.found()
	dsoup = dependency('libsoup-2.4', version: '>=2.64.2')
	prj_args += ['-D', '__SOUP_VERSION_2_70__']
	message('LIBSOUP 2 FOUND')
endif

dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gmodule-2.0'),
	dependency('gee-0.8'),
	dependency('json-glib-1.0'),
	dependency('libxml-2.0'),
	dsoup,
	dependency('sqlite3'),
	#meson.get_compiler('vala').find_library('mysql'),
	dependency('mysql'),
	dependency('libpq'),
	meson.get_compiler('c').find_library('SinticBolivia', dirs: sbframework_dir)
]

if SO_TARGET == 'MACOS'
	#link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
	#link_args += '-lSinticBolivia'
elif SO_TARGET == 'LINUX'
  #link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
  #link_args += '-lSinticBolivia'
endif

message('MESON BASE DIR', meson.current_source_dir() )
message('SBFRAMEWORK PATH: ' + sbframework_dir)

sources = [
  'Entities/Plan.vala',
  'Entities/UserPlan.vala',
	'Entities/CustomerPlan.vala',
  'Entities/Payment.vala',
	'Entities/Type.vala',
	'Dto/DtoWhatsAppMessage.vala',
	'Services/ServiceWhatsApp.vala',
  'Models/SubscriptionsModel.vala',
  'Models/PlansModel.vala',
  'Controllers/SubscriptionsController.vala',
  'Controllers/PlansController.vala',
	'Controllers/TypesController.vala',
  'rest_module.vala'
]
add_project_arguments(prj_args, language: 'vala')

libsubscriptions = shared_library(
	'subscriptions',
	sources,
	# vala_header: 'libsiat.h',
	# vala_vapi: 'siat.vapi',
	dependencies: dependencies,
	include_directories : include_directories(inc_directories),
	install: true
)
libsubscriptions_dep = declare_dependency(
	include_directories : include_directories('.'), #include_dir,
	link_with : libsubscriptions
)
