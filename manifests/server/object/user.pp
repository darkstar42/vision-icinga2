# user class
class vision_icinga2::server::object::user (
  Hash $groups = hiera_hash('vision::groups', { }),
  Hash $users = hiera_hash('vision::users', { }),
  String $notification_group = hiera('icinga2::notification::group', 'vision-sysadmin'),
  String $notification_email = hiera('icinga2::notification::email', 'vision-it@iis.fraunhofer.de'),
) {
  ::icinga2::object::user { 'vision-it':
    templates    => ['generic-user'],
    display_name => 'Vision IT',
    email        => $notification_email,
    groups       => [
      $notification_group
    ],
  }

  $member = {}

  # Check if notification group exists
  if has_key($groups, $notification_group) {
    $group = $groups[$notification_group]

    # Then take all members of that group and check if they are defined
    $group['members'].each |$member| {
        if has_key($users, $member) {
          $user = $users[$member]

          # A user can have multiple emails, but we only want the notifications sent
          # to the private addresses
          $user['mail'].each |$email| {
              if ! ('iis.fraunhofer.de' in $email) {
                ::icinga2::object::user { $member:
                  templates    => ['generic-user'],
                  display_name => $user['commonName'],
                  pager        => $user['mobile'],
                  email        => $email,
                  groups       => [
                    $notification_group
                  ],
                }
              }
            }
        }
      }
  }
}
