#include <cstdint>
#include <cstdlib>
#include <string>
#include "esphome.h"
#include "esphome/core/log.h"
#include "myHelpers.h"

uint16_t swapBytes(uint16_t value)
{
  return (value << 8) | (value >> 8);
}

uint16_t swapBytes(const std::string& value)
{
  const char* logTag = "myHelpers";
  char* end = nullptr;
  const unsigned long parsed = std::strtoul(value.c_str(), &end, 10);
  if (end == value.c_str() || *end != '\0' || parsed > 0xFFFFUL) {
    esphome::ESP_LOGW(logTag, "swapBytes received invalid value '%s'", value.c_str());
    return 0;
  }

  const uint16_t intValue = static_cast<uint16_t>(parsed);
  return (intValue << 8) | (intValue >> 8);
}

void updateUnknownSelect(uint16_t sensorIndex, esphome::modbus_controller::ModbusSelect* selectComp)
{
  if (selectComp == nullptr) {
    esphome::ESP_LOGW("myHelpers", "updateUnknownSelect called with null component");
    return;
  }

  if (!selectComp->active_index().has_value() || sensorIndex != selectComp->active_index().value()) {
    auto call = selectComp->make_call();
    call.set_index(sensorIndex);
    call.perform();
  }
}



