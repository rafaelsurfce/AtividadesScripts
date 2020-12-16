#!/bin/bash

echo "Olá" $(hostname), " 
Hoje é dia" $(date +%d)", dos mês" $(date +%m)" do ano de" $(date +%G) | tee -a saudacao.log


