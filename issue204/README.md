The script `run.sh` will do the followings:

 - initialize 2 nodes and corresponding keys
 - set node 1 as genesis validator
 - start 2 nodes
 - start lite client
 - start Big Dipper (note that it will not run `meteor reset`, you may need to run it yourself)
 - send `CreateValidator` transaction from key 2 to create a new validator, with very little delegation
 - send `CreateValidator` transaction again (which will fail because of duplicated validator)
 - send `Delegate` transaction from key 2 to make node 2's delegation proportion the same as node 1

After these, the script will exit and you should be able to see abnormality on Big Dipper (http://localhost:3000), in validator list and block list.

The nodes, lite client and Big Dipper will not be killed, so you will need to kill them yourself.

If you don't have other important process running, you can use this command: `pkill gaiad gaiacli node`

The home directories of `gaiad` and `gaiacli` are separated from the global ones, namely `gaiad-home-1`, `gaiad-home-2` and `gaiacli-home`.