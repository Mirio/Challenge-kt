[all]
${master_hosts}
${node_hosts}

[kube_control_plane]
${master_index}

[etcd]
${master_index}

[kube_node]
${nodes_index}

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr