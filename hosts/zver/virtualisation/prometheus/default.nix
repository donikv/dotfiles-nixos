{ config, pkgs, system, ... }: 
  let 
     run-docker-monitoring = pkgs.writeShellScriptBin "run-docker-monitoring" ''
        name='nvidia-dcgm-exporter'
        echo "Running $name"
        [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || docker run --gpus all -d --restart=always --name=$name nvidia/dcgm-exporter:1.0.0-beta
      
        name='prometheus-node-exporter'
        echo "Running $name"
        [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || docker run -d --restart=always --net="host" --pid="host" --name=$name --volumes-from nvidia-dcgm-exporter:ro quay.io/prometheus/node-exporter --collector.textfile.directory="/run/prometheus"        
        
        name='cadvisor'
        echo "Running $name"
        [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || sudo docker run --restart=always --volume=/:/rootfs:ro   --volume=/var/run:/var/run:ro   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --volume=/dev/disk/:/dev/disk:ro   --publish=8080:8080   --detach=true   --name=$name   gcr.io/cadvisor/cadvisor:latest
      '';
in
{
  environment.systemPackages = with pkgs; [
    run-docker-monitoring
  ];
  #system.activationScripts = {
  #  runDocker = {
  #    deps = [ "docker" "sudo" ];
  #    text = ''
  #      name='nvidia-dcgm-exporter'
  #      [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || docker run --gpus all -d --restart=always --name=$name nvidia/dcgm-exporter:1.0.0-beta
  #    
  #      name='prometheus-node-exporter'
  #      [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || docker run -d --restart=always --net="host" --pid="host" --name=$name --volumes-from nvidia-dcgm-exporter:ro quay.io/prometheus/node-exporter --collector.textfile.directory="/run/prometheus"        
  #      
  #      name='nvidia-dcgm-exporter'
  #      [[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] || sudo docker run --restart=always --volume=/:/rootfs:ro   --volume=/var/run:/var/run:ro   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --volume=/dev/disk/:/dev/disk:ro   --publish=8080:8080   --detach=true   --name=$name   gcr.io/cadvisor/cadvisor:latest
  #    '';
  #  };
  #};
  
  #virtualisation.oci-containers = {
  #  backend = "docker";
  #  containers = {
  #    # NVIDIA DCGM Exporter
  #    nvidia-dcgm-exporter = {
  #      image = "nvidia/dcgm-exporter:1.0.0-beta";
  #      extraOptions = ["-d" "--restart=always" "--gpus=all"];
  #    };

  #    # Prometheus Node Exporter
  #    prometheus-node-exporter = {
  #      image = "quay.io/prometheus/node-exporter";
  #      volumes = [
  #        # Mount `nvidia-dcgm-exporter` volumes in read-only mode
  #        "nvidia-dcgm-exporter:/run/prometheus:ro"
  #      ];
  #      extraOptions = [
  #        "-d" "--restart=always" "--network=host" "--pid=\"host\"" 
  #      ]; 
  #      cmd = ["--collector.textfile.directory=/run/prometheus"];
  #    };

  #    # Google cAdvisor
  #    cadvisor = {
  #      image = "gcr.io/google-containers/cadvisor:latest";
  #      ports = [
  #        "8080:8080" # Publish port 8080
  #      ];
  #      volumes = [
  #        "/:/rootfs:ro"
  #        "/var/run:/var/run:ro"
  #        "/sys:/sys:ro"
  #        "/var/lib/docker:/var/lib/docker:ro"
  #        "/dev/disk:/dev/disk:ro"
  #      ];
  #      extraOptions = ["--detach=true" "--restart=always"]; # Detached mode
  #    };
  #  };
  #};

}
