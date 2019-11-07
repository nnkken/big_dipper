#!/bin/bash

set -e

PASSWORD="password"
SEED_1="neither service visual tackle goose garment peace sibling gun option use baby buyer cousin hockey road radar oven decorate pig equal pioneer time display"
SEED_2="final coffee shop slight human vintage clown absorb vacuum nature pelican vanish kitten oppose better bridge diamond shield lottery text boat face black various"
VAL_ADDR_1="cosmosvaloper1s9pvkz9nvefjc0xtphrhhh7plyfze2rthxlqr8"
VAL_ADDR_2="cosmosvaloper1m9mgul3gl2kc8mk9wmkczwkxctl4lp5xu8ujz0"
CHAIN_ID="big-dipper-issue-204-test-chain"

DIR="$(dirname $0)"
pushd "$DIR"
DIR=$(pwd)

gaiad init --home gaiad-home-1 validator-1 --chain-id "$CHAIN_ID"
printf "$PASSWORD\n$SEED_1\n" | gaiacli --home gaiacli-home keys add validator-1 --recover
printf "$PASSWORD\n$SEED_2\n" | gaiacli --home gaiacli-home keys add validator-2 --recover

gaiad --home gaiad-home-1 add-genesis-account --home-client gaiacli-home validator-1 100000000000000stake
gaiad --home gaiad-home-1 add-genesis-account --home-client gaiacli-home validator-2 100000000000000stake
echo "$PASSWORD" | gaiad --home gaiad-home-1 gentx --home-client gaiacli-home --name validator-1 --amount 100000000000000stake
gaiad --home gaiad-home-1 collect-gentxs

gaiad init --home gaiad-home-2 validator-2
cp gaiad-home-1/config/genesis.json gaiad-home-2/config/genesis.json

VAL_1_NODE_ID=$(gaiad --home gaiad-home-1 tendermint show-node-id)

gaiad --home gaiad-home-1 start &
gaiad --home gaiad-home-2 start --p2p.laddr 'tcp://0.0.0.0:26666' --rpc.laddr 'tcp://127.0.0.1:26667' --p2p.persistent_peers "$VAL_1_NODE_ID@127.0.0.1:26656" &

sleep 10

gaiacli rest-server --chain-id "$CHAIN_ID" --home gaiacli-home &

sleep 10

(cd .. && meteor run --settings "$DIR/settings.json" &)

sleep 60

VAL_2_CONS_PUB_KEY=$(gaiad --home gaiad-home-2 tendermint show-validator)

printf "$PASSWORD\n" | gaiacli --home gaiacli-home tx staking create-validator --yes --amount 1stake --from validator-2 --moniker 'validator-2' --pubkey "$VAL_2_CONS_PUB_KEY" --chain-id "$CHAIN_ID" --min-self-delegation 1 --commission-rate 0.1 --commission-max-rate 0.5 --commission-max-change-rate 0.5

sleep 30

printf "$PASSWORD\n" | gaiacli --home gaiacli-home tx staking create-validator --yes --amount 1stake --from validator-2 --moniker 'validator-2' --pubkey "$VAL_2_CONS_PUB_KEY" --chain-id "$CHAIN_ID" --min-self-delegation 1 --commission-rate 0.1 --commission-max-rate 0.5 --commission-max-change-rate 0.5

sleep 30

printf "$PASSWORD\n" | gaiacli --home gaiacli-home tx staking delegate --yes "$VAL_ADDR_2" 99999999999999stake  --from validator-2 --chain-id "$CHAIN_ID"

popd