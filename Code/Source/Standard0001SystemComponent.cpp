
#include <AzCore/Serialization/SerializeContext.h>
#include <AzCore/Serialization/EditContext.h>
#include <AzCore/Serialization/EditContextConstants.inl>

#include "Standard0001SystemComponent.h"

namespace Standard0001
{
    void Standard0001SystemComponent::Reflect(AZ::ReflectContext* context)
    {
        if (AZ::SerializeContext* serialize = azrtti_cast<AZ::SerializeContext*>(context))
        {
            serialize->Class<Standard0001SystemComponent, AZ::Component>()
                ->Version(0)
                ;

            if (AZ::EditContext* ec = serialize->GetEditContext())
            {
                ec->Class<Standard0001SystemComponent>("Standard0001", "[Description of functionality provided by this System Component]")
                    ->ClassElement(AZ::Edit::ClassElements::EditorData, "")
                        ->Attribute(AZ::Edit::Attributes::AppearsInAddComponentMenu, AZ_CRC("System"))
                        ->Attribute(AZ::Edit::Attributes::AutoExpand, true)
                    ;
            }
        }
    }

    void Standard0001SystemComponent::GetProvidedServices(AZ::ComponentDescriptor::DependencyArrayType& provided)
    {
        provided.push_back(AZ_CRC("Standard0001Service"));
    }

    void Standard0001SystemComponent::GetIncompatibleServices(AZ::ComponentDescriptor::DependencyArrayType& incompatible)
    {
        incompatible.push_back(AZ_CRC("Standard0001Service"));
    }

    void Standard0001SystemComponent::GetRequiredServices([[maybe_unused]] AZ::ComponentDescriptor::DependencyArrayType& required)
    {
    }

    void Standard0001SystemComponent::GetDependentServices([[maybe_unused]] AZ::ComponentDescriptor::DependencyArrayType& dependent)
    {
    }
    
    Standard0001SystemComponent::Standard0001SystemComponent()
    {
        if (Standard0001Interface::Get() == nullptr)
        {
            Standard0001Interface::Register(this);
        }
    }

    Standard0001SystemComponent::~Standard0001SystemComponent()
    {
        if (Standard0001Interface::Get() == this)
        {
            Standard0001Interface::Unregister(this);
        }
    }

    void Standard0001SystemComponent::Init()
    {
    }

    void Standard0001SystemComponent::Activate()
    {
        Standard0001RequestBus::Handler::BusConnect();
    }

    void Standard0001SystemComponent::Deactivate()
    {
        Standard0001RequestBus::Handler::BusDisconnect();
    }
}
