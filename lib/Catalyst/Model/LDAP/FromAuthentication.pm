package Catalyst::Model::LDAP::FromAuthentication;
use Moose;
use Catalyst::Model::LDAP::Connection;
use Catalyst::Model::LDAP::Entry;
use 5.005003;
use namespace::autoclean;

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;

extends qw/Catalyst::Model::LDAP/;

with 'Catalyst::Component::InstancePerContext';

after COMPONENT => sub {
    my ($class, $c, $args) = @_;
    die("Application is not using Catalyst::Plugin::Authentication, $class cannot work.\n") unless $c->can('user');
};

sub build_per_context_instance {
    my ($self, $c) = @_;
    my $user = $c->user;
    die("No authenticated user") unless $user;
    # FIXME - This is crap, why do I need to do any of this!
    my $i = $user->can('_ldap_connection') ? $user->_ldap_connection->()
        : $user->ldap_connection;
    my $model = bless $i, 'Catalyst::Model::LDAP::Connection';
    $model->{entry_class} ||= 'Catalyst::Model::LDAP::Entry';
    $model->{base} ||= 'dc=cissme, dc=com';
    return $model;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Catalyst::Model::LDAP::FromAuthentication - Provides an LDAP model bound as the user who logged in.

=head2 SYNOPSIS

    package MyApp::Model::LDAP;
    use Moose;
    use namespace::autoclean;

    extends 'Catalyst::Model::LDAP::FromAuthentication';

    # Elsewhere
    $c->model('LDAP');

=head2 DESCRIPTION

This model is a shim used to mash up L<Catalyst::Authentication::Store::LDAP>
and L<Catalyst::Model::LDAP>.

It will return L<Catalyst::Authentication::Store::LDAP> object bound to the
directory as the logged in user.

=head1 AUTHOR

Tomas Doran (t0m) C<< <bobtfish@bobtfish.net >>

=head1 COPYRIGHT

Copyright 2009 state51

=head1 LICENSE

his program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

