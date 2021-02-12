#!/bin/bash

echo """
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: humio4cp4m
  namespace: openshift-marketplace
spec:
  displayName: Humio for IBM Cloudpak for Multicloud Management
  publisher: IBM
  sourceType: grpc
  image: ${INDEX_IMG}
  updateStrategy:
    registryPoll:
      interval: 45m
""" | oc apply -f -