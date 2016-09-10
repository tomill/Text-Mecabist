package Text::Mecabist;
use 5.010001;
use strict;
use warnings;
our $VERSION = "0.01";

use Moo;
use Encode;
use Text::MeCab;
use Text::Mecabist::Document;
use Text::Mecabist::Node;

has mecab => (is => 'rw');

my $encoding;
sub encoding {
    $encoding ||= Encode::find_encoding(Text::MeCab::ENCODING);
}

sub BUILD {
    my ($self, $args) = @_; 
    my $mecab = delete $args->{mecab} || Text::MeCab->new($args);
    $self->mecab($mecab);
}

sub parse {
    my ($self, $text, $cb) = @_;
    my $doc = Text::Mecabist::Document->new;
    
    $text = $self->encoding->encode($text);
    
    for my $part (split /(\s+)/, $text) {
        if ($part =~ /^\s+$/) {
            my $node = Text::Mecabist::Node->new({
                text => $part,
            });
            
            $doc->add($node);
            next;
        }
        
        foreach (
            my $node = $self->mecab->parse($part);
            $node;
            $node = $node->next()
        ) {
            my $node = Text::Mecabist::Node->new($node, $self);
            $doc->add($node);
        }
    }

    if ($cb) {
        $doc->each($cb);
    }
    
    $doc;
}

1;
__END__

=encoding utf-8

=head1 NAME

Text::Mecabist - It's new $module

=head1 SYNOPSIS

    use Text::Mecabist;

=head1 DESCRIPTION

Text::Mecabist is ...

=head1 LICENSE

Copyright (C) Naoki Tomita.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=cut
