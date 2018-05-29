#!/bin/bash

source veiculo.sh

getVelocidade
setVelocidade 10
var=$(getVelocidade)
echo "Agora estamos a $var K/h"
