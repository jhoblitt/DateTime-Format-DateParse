package DateTime::Format::DateParse;

# Copyright (C) 2005  Joshua Hoblitt
#
# $Id: DateParse.pm 3364 2005-07-21 09:22:37Z jhoblitt $

use strict;

use vars qw($VERSION);
$VERSION = '0.01';

use DateTime;
use DateTime::TimeZone;
use Date::Parse;
use Time::Zone;

sub parse_datetime {
    my ($class, $date, $zone) = @_;

    # unless there is an explict ZONE, Date::Parse seems to parse date only
    # formats, eg. 1995-01-24, as being in the 'local' timezone.
    # possibly a bug?
    $zone ||= 'UTC';

    my $time = str2time( $date, $zone );

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
