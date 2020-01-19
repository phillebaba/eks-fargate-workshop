#!/bin/sh

echo "Starting time measurement"

kubectl delete job time-ec2 > /dev/null 2>&1
START=`date +%s`
kubectl apply -f time_ec2_job.yaml > /dev/null 2>&1
kubectl wait --for=condition=complete job/time-ec2 > /dev/null 2>&1
END=`date +%s`
RUNTIME=$((END-START))
kubectl delete job time-ec2 > /dev/null 2>&1
echo "EC2 time: $RUNTIME seconds"

kubectl delete job time-fargate > /dev/null 2>&1
START=`date +%s`
kubectl apply -f time_fargate_job.yaml > /dev/null 2>&1
kubectl wait --timeout=500s --for=condition=complete job/time-fargate > /dev/null 2>&1
END=`date +%s`
RUNTIME=$((END-START))
kubectl delete job time-fargate > /dev/null 2>&1
echo "Fargate time: $RUNTIME seconds"

echo "Time measurement completed"
