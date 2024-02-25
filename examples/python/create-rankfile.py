def generate_rankfile(hostfile_path):
    rankfile_content = ""
    rank_id = 0
    try:
        with open(hostfile_path, "r") as hostfile:
            hosts = hostfile.readlines()
            num_hosts = len(hosts)
            ranks_per_host = 64
            for host in enumerate(hosts):
                hostname = host.strip()
                for rank in range(ranks_per_host):
                    rank_content = f"rank {rank_id}={hostname} slot=0-63"
                    rankfile_content += rank_content + '\n'
                    rank_id = rank_id + 1

        with open("rankfile", "w") as rankfile:
            rankfile.writelines(rankfile_content)

        print("Rankfile generated successfully.")
    except FileNotFoundError:
        print(f"Error: File {hostfile_path} not found.")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# 请将hostfile_path变量替换为你自己的hostfile文件路径
hostfile_path = "hostfile.2"
generate_rankfile(hostfile_path)