#!/bin/bash

az deployment group create \
  --resource-group dev-storage-ad\
  --template-file storageTemplate.json \
  --parameters @storageTemplate.parameters.json
