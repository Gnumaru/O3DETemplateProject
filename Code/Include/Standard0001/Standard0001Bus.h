
#pragma once

#include <AzCore/EBus/EBus.h>
#include <AzCore/Interface/Interface.h>

namespace Standard0001
{
    class Standard0001Requests
    {
    public:
        AZ_RTTI(Standard0001Requests, "{ab1607e4-3648-4514-b89c-7725bd1c4c9d}");
        virtual ~Standard0001Requests() = default;
        // Put your public methods here
    };
    
    class Standard0001BusTraits
        : public AZ::EBusTraits
    {
    public:
        //////////////////////////////////////////////////////////////////////////
        // EBusTraits overrides
        static constexpr AZ::EBusHandlerPolicy HandlerPolicy = AZ::EBusHandlerPolicy::Single;
        static constexpr AZ::EBusAddressPolicy AddressPolicy = AZ::EBusAddressPolicy::Single;
        //////////////////////////////////////////////////////////////////////////
    };

    using Standard0001RequestBus = AZ::EBus<Standard0001Requests, Standard0001BusTraits>;
    using Standard0001Interface = AZ::Interface<Standard0001Requests>;

} // namespace Standard0001
