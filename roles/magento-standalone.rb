name "magento-standalone"
description "Magento standalone server"
run_list "recipe[magento_standalone::default]"
override_attributes({
  
})
