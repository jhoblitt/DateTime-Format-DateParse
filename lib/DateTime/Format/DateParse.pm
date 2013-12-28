package DateTime::Format::DateParse;

# Copyright (C) 2005  Joshua Hoblitt
#
# $Id: DateParse.pm 3380 2005-07-23 02:15:32Z jhoblitt $

use strict;

use vars qw($VERSION);
$VERSION = '0.01';

use DateTime;
use DateTime::TimeZone;
use Date::Parse qw( str2time );
use Time::Zone qw( tz_offset );

sub parse_datetime {
    my ($class, $date, $zone) = @_;

    my $time = str2time( $date, $zone );

    return undef unless $time;

    # unless there is an explict ZONE, Date::Parse seems to parse date only
    # formats, eg. 1995-01-24, as being in the 'local' timezone.
    unless ( $zone ) {
        return DateTime->from_epoch(
            epoch       => $time,
            time_zone   => 'local',
        );
    }

    if ( DateTime::TimeZone->is_valid_name( $zone ) ) {
        return DateTime->from_epoch(
            epoch       => $time,
            time_zone   => $zone,
        );
    } else {
        # attempt to convert Time::Zone tz's into an offset
        return DateTime->from_epoch(
            epoch       => $time,
            time_zone   =>
                DateTime::TimeZone::offset_as_string( tz_offset( $zone ) ),
        );
    }
}

1;

__END__
