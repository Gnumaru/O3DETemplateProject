
#pragma once

#include <AzCore/Component/Component.h>

#include <Standard0001/Standard0001Bus.h>

namespace Standard0001
{
    class Standard0001SystemComponent
        : public AZ::Component
        , protected Standard0001RequestBus::Handler
    {
    public:
        AZ_COMPONENT(Standard0001SystemComponent, "{2a3eff9d-eb64-4146-a49f-102e1a65df2c}");

        static void Reflect(AZ::ReflectContext* context);

        static void GetProvidedServices(AZ::ComponentDescriptor::DependencyArrayType& provided);
        static void GetIncompatibleServices(AZ::ComponentDescriptor::DependencyArrayType& incompatible);
        static void GetRequiredServices(AZ::ComponentDescriptor::DependencyArrayType& required);
        static void GetDependentServices(AZ::ComponentDescriptor::DependencyArrayType& dependent);

        Standard0001SystemComponent();
        ~Standard0001SystemComponent();

    protected:
        ////////////////////////////////////////////////////////////////////////
        // Standard0001RequestBus interface implementation

        ////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////
        // AZ::Component interface implementation
        void Init() override;
        void Activate() override;
        void Deactivate() override;
        ////////////////////////////////////////////////////////////////////////
    };
}
