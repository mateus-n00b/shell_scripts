#!/bin/bash
# Object-oriented programming?
# 
#
# Mateus Sousa (n00b)
#
vel=0
gas=0

setVelocidade()
{
  vel=$1
}


getVelocidade()
{
  echo "$vel"
}

setCombustivel()
{
  gas=$1 
}

getCombustivel()
{
  echo "$gas"
}
