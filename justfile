[group("Podman")]
[doc("List all available commands.")]
@default:
  just --list --unsorted

[group("Bitcoin Core")]
[doc("Print the current session cookie to console.")]
@cookie:
  podman exec RegtestBitcoinEnv cat /root/.bitcoin/regtest/.cookie | cut -d ':' -f2

[group("Bitcoin Core")]
[doc("Mine a block, or mine <BLOCKS> number of blocks.")]
@mine BLOCKS="1":
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE generatetoaddress {{BLOCKS}} bcrt1q6gau5mg4ceupfhtyywyaj5ge45vgptvawgg3aq

[group("Bitcoin Core")]
[doc("Send mining reward to <ADDRESS>")]
@sendminingrewardto ADDRESS:
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE generatetoaddress 1 {{ADDRESS}}

[group("Bitcoin Core")]
[doc("Send a command to bitcoin-cli")]
@cli COMMAND:
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE {{COMMAND}}

[group("Logs")]
[doc("Print all logs to console.")]
logs:
  podman logs RegtestBitcoinEnv

[group("Logs")]
[doc("Print bitcoin daemon logs to console.")]
bitcoindlogs:
  podman exec -it RegtestBitcoinEnv tail -f /root/log/bitcoin.log

[group("Logs")]
[doc("Print Esplora logs to console.")]
esploralogs:
  podman exec -it RegtestBitcoinEnv tail -f /root/log/esplora.log

[group("Logs")]
[doc("Print block explorer logs to console.")]
explorerlogs:
  podman exec -it RegtestBitcoinEnv tail -f /root/log/fbbe.log

[group("Podman")]
[doc("Start your podman machine and regtest environment.")]
start:
  podman machine start regtest
  podman start RegtestBitcoinEnv

[group("Podman")]
[doc("Stop your podman machine and regtest environment.")]
stop:
  podman stop RegtestBitcoinEnv
  podman machine stop regtest

[group("Podman")]
[doc("Enter the shell in the pod.")]
podshell:
  podman exec -it RegtestBitcoinEnv /bin/bash

[group("Podman")]
[doc("Open the block explorer.")]
explorer:
  open http://127.0.0.1:3003

[group("Docs")]
[doc("Serve the local docs.")]
servedocs:
  mkdocs serve

[group("Docs")]
[doc("Open the website for docs.")]
docs:
  open https://thunderbiscuit.github.io/regtest-in-a-pod/

[group("Default Wallet")]
[doc("Create a default wallet.")]
@createwallet:
  COOKIE=$(just cookie) \
  && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE createwallet podmanwallet \
  && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE -rpcwallet=podmanwallet settxfee 0.0001

[group("Default Wallet")]
[doc("Print an address from the default wallet.")]
@newaddress:
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE -rpcwallet=podmanwallet getnewaddress

[group("Default Wallet")]
[doc("Print the balance of the default wallet.")]
@walletbalance:
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE -rpcwallet=podmanwallet getbalance

[group("Default Wallet")]
[doc("Send 1 bitcoin to <ADDRESS> using the default wallet.")]
@sendto ADDRESS:
  COOKIE=$(just cookie) && bitcoin-cli --chain=regtest --rpcuser=__cookie__ --rpcpassword=$COOKIE -rpcwallet=podmanwallet sendtoaddress {{ADDRESS}} 1
