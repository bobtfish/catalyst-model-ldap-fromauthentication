use inc::Module::Install;

name 'Catalyst-Model-LDAP-FromAuthentication';
all_from 'lib/Catalyst/Model/LDAP/FromAuthentication.pm';

build_requires 'Catalyst::Runtime';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
