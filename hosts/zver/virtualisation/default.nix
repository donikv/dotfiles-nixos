{ config, pkgs, user, lib, ... }:
  let
    docker-gpu-insight = pkgs.writeShellScriptBin "docker-gpu-insight" ''
      nvidia-smi --query-compute-apps=used_memory,process_name,pid --format=csv | sort -g | sed '/^[0-9]/!d' | while read line ; do

	   MEM=$(echo $line | sed 's/^\([0-9]* [^ ,]*\).*/\1/')
	   PID=$(echo $line | sed 's/.* \([0-9]*\)$/\1/')
	   CID=$(cat /proc/$PID/cgroup | grep docker | head -n 1 | cut -d/ -f3)
	   DATA=$(docker inspect --format='{{.Name}} {{.HostConfig.Binds}}' $CID)
	
	   echo "# $DATA"
	   echo "Memory usage: $MEM"
	   echo "PID: $PID"
	   echo ""
	
	  done
    '';
in
{
  imports = [
    ./prometheus
  ];
  virtualisation = {
    docker.enable = true;
    docker.enableNvidia = true;
  };
  
  users.groups.docker = lib.mkForce {
    gid = 999;
  };
  
  users.groups.nscd = lib.mkForce {
    gid = 998;
  }; 
 
  #hardware.nvidia-container-toolkit.enable = true;
  
  #users.groups.docker.members = [ "ipg" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-gpu-insight
  ];
}
