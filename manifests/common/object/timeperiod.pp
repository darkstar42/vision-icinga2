# = Class: vision_icinga2::common::object::timeperiod
#
#

class vision_icinga2::common::object::timeperiod {
  ::icinga2::object::timeperiod { '24x7':
    timeperiod_display_name => 'Icinga 2 24x7 TimePeriod',
    ranges                  => {
      monday    => '00:00-24:00',
      tuesday   => '00:00-24:00',
      wednesday => '00:00-24:00',
      thursday  => '00:00-24:00',
      friday    => '00:00-24:00',
      saturday  => '00:00-24:00',
      sunday    => '00:00-24:00',
    },
  }

  ::icinga2::object::timeperiod { '9to5':
    timeperiod_display_name => 'Icinga 2 9to5 TimePeriod',
    ranges                  => {
      monday    => '09:00-17:00',
      tuesday   => '09:00-17:00',
      wednesday => '09:00-17:00',
      thursday  => '09:00-17:00',
      friday    => '09:00-17:00',
      saturday  => '09:00-17:00',
      sunday    => '09:00-17:00',
    },
  }

  ::icinga2::object::timeperiod { 'never':
    timeperiod_display_name => 'Icinga 2 never TimePeriod',
    ranges                  => {
    },
  }
}
