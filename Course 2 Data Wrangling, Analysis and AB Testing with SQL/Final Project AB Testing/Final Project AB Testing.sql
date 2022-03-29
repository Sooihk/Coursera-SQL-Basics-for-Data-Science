-- We are running an experiment at an item-level, which means all 
-- users who visit will see the same page, but the layout of different 
-- item pages may differ. 

--We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?

SELECT 
  * 
FROM 
  dsv1069.final_assignments_qa
  
-- Answer: No there is no data on date and time necessary to compute metrics like 30-day view binary


--Write a query and table creation statement to make final_assignments_qa look like the final_assignments table. 
--Reformat the final_assignments_qa to look like the final_assignments table, filling in 
--any missing values with a placeholder of the appropriate data type.

SELECT 
  item_id,
  test_a AS test_assignment,
  (CASE 
      WHEN test_a IS NOT NULL THEN 'test_a'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_a IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION 
SELECT 
  item_id,
  test_b AS test_assignment,
  (CASE 
      WHEN test_b IS NOT NULL THEN 'test_b'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_b IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION 
SELECT 
  item_id,
  test_c AS test_assignment,
  (CASE 
      WHEN test_c IS NOT NULL THEN 'test_c'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_c IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_d AS test_assignment,
  (CASE 
      WHEN test_d IS NOT NULL THEN 'test_d'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_d IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_e AS test_assignment,
  (CASE 
      WHEN test_e IS NOT NULL THEN 'test_e'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_e IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_f AS test_assignment,
  (CASE 
      WHEN test_f IS NOT NULL THEN 'test_f'
      ELSE NULL 
  END)      AS test_number,
  (CASE 
      WHEN test_f IS NOT NULL THEN CAST('2013-01-05 00:00:00' AS timestamp)
      ELSE NULL 
  END)      AS test_start_date
FROM 
  dsv1069.final_assignments_qa


-- Use the final_assignments table to calculate the order binary for the 30 day window after the test assignment for item_test_2 
SELECT order_binary.test_assignment,
       COUNT(DISTINCT order_binary.item_id) AS num_orders,
       SUM(order_binary.orders_binary_30d) AS sum_orders_bin_30d
FROM
  (SELECT final_assignments.item_id,
          final_assignments.test_assignment,
          MAX(CASE
                  WHEN (orders.created_at > final_assignments.test_start_date 
                        AND DATE_PART('day', orders.created_at - final_assignments.test_start_date 
                        ) <= 30) THEN 1
                  ELSE 0
              END) AS orders_binary_30d
   FROM dsv1069.final_assignments AS final_assignments
   LEFT JOIN dsv1069.orders AS orders
     ON final_assignments.item_id = orders.item_id
   WHERE final_assignments.test_number ='item_test_2'
   GROUP BY final_assignments.item_id,
            final_assignments.test_assignment
  ) AS order_binary
GROUP BY order_binary.test_assignment


-- Use this table to compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT 
  view_binary.test_assignment,
  COUNT(DISTINCT view_binary.item_id) AS num_views,
  SUM(view_binary.view_binary_30days) AS sum_view_binary_30days
FROM
  (
  SELECT 
    final_assignments.item_id,
    final_assignments.test_assignment,
    MAX(
      CASE
        WHEN (views.event_time > final_assignments.test_start_date 
        AND DATE_PART('day', views.event_time - final_assignments.test_start_date 
        ) <= 30) THEN 1
        ELSE 0
      END) AS view_binary_30days
  FROM dsv1069.final_assignments AS final_assignments
  LEFT JOIN 
    dsv1069.view_item_events AS views
  ON final_assignments.item_id = views.item_id
  WHERE final_assignments.test_number ='item_test_2'
  GROUP BY 
    final_assignments.item_id,
    final_assignments.test_assignment
  ) AS view_binary
GROUP BY view_binary.test_assignment
