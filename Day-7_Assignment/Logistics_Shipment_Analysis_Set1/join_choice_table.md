# Task 5 – Join-choice table

| Q | Business question | Join used | Why this join? |
|---|---|---|---|
| 1 | Delayed shipments + carrier | INNER | Only shipments with a matching carrier are needed. |
| 2 | Hubs with no outbound shipments | LEFT | Preserves all hubs, then filters unmatched shipment rows. |
| 3 | Employee + supervisor | SELF LEFT | Same table supplies supervisors; keeps employees without one. |
| 4 | Shipment + customer + destination | INNER | Only complete matching shipment/customer/hub records are relevant. |
| 5 | Customer shipment counts | LEFT | Keeps customers who have zero shipments. |
| 6 | Carrier shipment counts | RIGHT | Keeps carriers even when they have no shipments. |
| 7 | Delivered tracking events | INNER | Only events linked to actual shipments/customers are needed. |
| 8 | Shipment event counts | LEFT | Keeps shipments with no tracking events. |
| 9 | Carrier revenue | INNER | Revenue report is limited to carriers with shipments. |
| 10 | Coworkers under same supervisor | SELF INNER | Pairs rows from employees; excludes missing supervisor and duplicate/reversed pairs. |

