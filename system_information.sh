#!/bin/bash

# get the public and private ip address.
function get_private_public_ip_addresses {
  private_address=$(hostname -I)
  public_address=$(curl ifconfig.me)
  echo "private_ip_address: $private_address"
  echo "public_ip_address: $public_address"
}

# get the current user
function get_current_user {
  user=$($USER)
  echo "current user: $user"
}

# get cpu information
function get_cpu_information {
  cpu_count=$(grep cpu cores /proc/cpuinfo | wc -l)
  echo "there are $cpu_count CPUs."
}

# get memory information
function get_memory_information {
  total_mem=$(free -m | awk '/Mem:/{print $2}')
  used_mem=$(free -m | awk '/Mem:/{print $3}')
  unused_mem=$(($total_mem - $used_mem))
  echo "There is $unused_mem Mebibyte unused memory of total $total_mem Mebibyte."
}

# get top memomory and cpu process based on the argument
function get_top_processes {
  process_type="$1"  # "memory" or "cpu"
  case $process_type in
    memory)
      command="ps -eo pmem,pid,cmd | head -n 6"
      title="Top 5 Memory Processes"
      ;;
    cpu)
      command="ps -eo %cpu,pid,cmd | head -n 6"
      title="Top 5 CPU Processes"
      ;;
    *)
      echo "Invalid process type."
      return 1
      ;;
  esac

  echo "$title"
  echo "$process_type"
  $command | tail -n +2
}


function system_information_tool {
  while true; do
    clear
    echo "System Information Tool"
    echo "----------------------"
    echo "1. IP Addresses"
    echo "2. Current User"
    echo "3. CPU Information"
    echo "4. Memory Information"
    echo "5. Top 5 Memory Processes"
    echo "6. Top 5 CPU Processes"
    echo "7. Exit"
    echo "----------------------"
    read -p "Enter your choice (1-8): " choice

    case $choice in
      1)
        get_private_public_ip_addresses
        ;;
      2)
        get_current_user
        ;;
      3)
        get_cpu_information
        ;;
      4)
        get_memory_information
        ;;
      5)
        get_top_processes "memory"
        ;;
      6)
        get_top_processes "cpu"
        ;;
      7)
        echo "Exiting..."
        break
        ;;
      *)
        echo "Invalid choice."
        ;;
    esac
    read -p "Press Enter to continue..."
  done
}

system_information_tool