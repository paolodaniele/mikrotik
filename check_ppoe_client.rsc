##### Script Settings  #####
# Remeber to change WanName with your pppoe-client if name

:local WanName "pppoe-telecom1"
:local HostPingA "8.8.8.8"
:local HostPingB "208.67.220.220"
#####################

:local PingCount "5"
:local WanStat
/interface pppoe-client monitor $WanName once do={ :set WanStat $status}
:if ($WanStat = "connected") do={
  :local pingresultA [/ping $HostPingA count=$PingCount];
    :if ($pingresultA = 0) do={ 
      :local pingresultB [/ping $HostPingB count=$PingCount]; 
      :if ($pingresultB = 0) do={ 
        :log error message="Not valid ping result from <$WanName>. Try to reconnect..."; 
        :interface pppoe-client disable $WanName; 
        :delay 5; 
        :interface pppoe-client enable $WanName; 
        :log warning message="PPPoE has Reconnected successfully";
        :delay 5;
        # This is useful if you have IP Cloud service active to force reload of DDNS
        :ip cloud force-update 
      }
    }
}
