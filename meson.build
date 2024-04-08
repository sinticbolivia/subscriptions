project('Subscriptions', 'vala', 'c', version: '1.0.0')
vapi_dir = meson.current_source_dir()  + '/src/vapi'
inc_directories = ['.']
SO_TARGET = get_option('so_target')
sbframework_dir = get_option('libsinticbolivia')

link_args = []
subsystem = false
#env = environment()
#env.append('PKG_CONFIG_PATH', '')

# add libSinticBolivia library
add_project_arguments(['--pkg', 'SinticBolivia'], language: 'vala')
dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gmodule-2.0'),
	dependency('gee-0.8'),
	dependency('json-glib-1.0'),
	dependency('libxml-2.0'),
	dependency('sqlite3'),
	meson.get_compiler('vala').find_library('mysql'),
    dependency('libpq'),
]
if SO_TARGET == 'MACOS'
	# sbframework_dir = '../../vala/desktop-framework'
	add_project_arguments(['--vapidir', meson.current_source_dir() + '/' + sbframework_dir], language: 'vala')
	dependencies += dependency('libsoup-3.0', version: '>=3.0.4')
	dependencies += meson.get_compiler('c').find_library('SinticBolivia', dirs: meson.current_source_dir() + '/' + sbframework_dir)
	inc_directories = ['../' + sbframework_dir]
	link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
	link_args += '-lSinticBolivia'
elif SO_TARGET == 'LINUX'
    # sbframework_dir = '../../vala/desktop-framework'
    add_project_arguments(['--vapidir', meson.current_source_dir() + '/' + sbframework_dir], language: 'vala')
    dependencies += dependency('libsoup-2.4', version: '>=2.64.2')
    dependencies += meson.get_compiler('c').find_library('SinticBolivia', dirs: meson.current_source_dir() + '/' + sbframework_dir)
    inc_directories = ['../' + sbframework_dir]
    link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
    link_args += '-lSinticBolivia'
endif

message('MESON BASE DIR', meson.current_source_dir() )
message('SBFRAMEWORK PATH: ' + sbframework_dir)

include_dir = include_directories(inc_directories)
sources = [
    'Entities/Plan.vala',
    'Entities/UserPlan.vala',
	'Entities/CustomerPlan.vala',
    'Entities/Payment.vala',
	'Entities/Type.vala',
    'Models/SubscriptionsModel.vala',
    'Models/PlansModel.vala',
    'Controllers/SubscriptionsController.vala',
    'Controllers/PlansController.vala',
	'Controllers/TypesController.vala',
    'rest_module.vala'
]


libsubscriptions = shared_library(
	'subscriptions',
	sources,
	# vala_header: 'libsiat.h',
	# vala_vapi: 'siat.vapi',
	dependencies: dependencies,
	include_directories : include_dir,
	install: true
)
libsubscriptions_dep = declare_dependency(
	include_directories : include_dir,
	link_with : libsubscriptions
)
