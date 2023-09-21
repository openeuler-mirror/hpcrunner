def generate_rankfile(hostfile_path):
    rankfile_content = ""
    rank_id = 0
    with open(hostfile_path, "r") as hostfile:
        hosts = hostfile.readlines()
        num_hosts = len(hosts)
        ranks_per_host = 64
        for host_id, host in enumerate(hosts):
            hostname = host.strip()
            for rank in range(ranks_per_host):
                rank_content = f"rank {rank_id}={hostname} slot=0-63"
                rankfile_content += rank_content + '\n'
                rank_id = rank_id + 1

    with open("rankfile", "w") as rankfile:
        rankfile.writelines(rankfile_content)

    print("Rankfile generated successfully.")

# 请将hostfile_path变量替换为你自己的hostfile文件路径
hostfile_path = "hostfile.2"
generate_rankfile(hostfile_path)