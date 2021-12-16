
#include <AzCore/Memory/SystemAllocator.h>
#include <AzCore/Module/Module.h>

#include "Standard0001SystemComponent.h"

namespace Standard0001
{
    class Standard0001Module
        : public AZ::Module
    {
    public:
        AZ_RTTI(Standard0001Module, "{1be4d500-2da4-4c51-bfff-1695e1271261}", AZ::Module);
        AZ_CLASS_ALLOCATOR(Standard0001Module, AZ::SystemAllocator, 0);

        Standard0001Module()
            : AZ::Module()
        {
            // Push results of [MyComponent]::CreateDescriptor() into m_descriptors here.
            m_descriptors.insert(m_descriptors.end(), {
                Standard0001SystemComponent::CreateDescriptor(),
            });
        }

        /**
         * Add required SystemComponents to the SystemEntity.
         */
        AZ::ComponentTypeList GetRequiredSystemComponents() const override
        {
            return AZ::ComponentTypeList{
                azrtti_typeid<Standard0001SystemComponent>(),
            };
        }
    };
}// namespace Standard0001

AZ_DECLARE_MODULE_CLASS(Gem_Standard0001, Standard0001::Standard0001Module)
