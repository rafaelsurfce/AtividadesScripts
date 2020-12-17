#!/bin/bash
# Correção: Parcialmente OK.
echo "Olá" $(whoami), " 
Hoje é dia" $(date +%d)", dos mês" $(date +%m)" do ano de" $(date +%G) | tee -a saudacao.log


