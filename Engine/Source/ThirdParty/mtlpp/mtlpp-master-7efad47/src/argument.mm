/*
 * Copyright 2016-2017 Nikolay Aleksiev. All rights reserved.
 * License: https://github.com/naleksiev/mtlpp/blob/master/LICENSE
 */
// Copyright 1998-2018 Epic Games, Inc. All Rights Reserved.
// Modifications for Unreal Engine

#include <Metal/MTLArgument.h>
#include "argument.hpp"

MTLPP_BEGIN

namespace mtlpp
{
	Type::Type() :
	ns::Object<MTLType*>([[MTLType alloc] init], false)
	{
		
	}
	
	DataType Type::GetDataType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return DataType([(MTLType*)m_ptr dataType]);
#else
		return 0;
#endif
	}
	
	TextureReferenceType::TextureReferenceType() :
	ns::Object<MTLTextureReferenceType*>([[MTLTextureReferenceType alloc] init], false)
	{
		
	}
	
	DataType   TextureReferenceType::GetTextureDataType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return DataType([(MTLTextureReferenceType*)m_ptr textureDataType]);
#else
		return 0;
#endif
	}
	
	TextureType   TextureReferenceType::GetTextureType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return TextureType([(MTLTextureReferenceType*)m_ptr textureType]);
#else
		return 0;
#endif
	}
	
	ArgumentAccess TextureReferenceType::GetAccess() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ArgumentAccess([(MTLTextureReferenceType*)m_ptr access]);
#else
		return 0;
#endif
	}
	
	bool TextureReferenceType::IsDepthTexture() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ([(MTLTextureReferenceType*)m_ptr isDepthTexture]);
#else
		return false;
#endif
	}
	
	PointerType::PointerType() :
	ns::Object<MTLPointerType*>([[MTLPointerType alloc] init], false)
	{
	}
	
	DataType   PointerType::GetElementType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return DataType([(MTLPointerType*)m_ptr elementType]);
#else
		return 0;
#endif
	}
	
	ArgumentAccess PointerType::GetAccess() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ArgumentAccess([(MTLPointerType*)m_ptr access]);
#else
		return 0;
#endif
	}
	
	NSUInteger PointerType::GetAlignment() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ([(MTLPointerType*)m_ptr alignment]);
#else
		return 0;
#endif
	}
	
	NSUInteger PointerType::GetDataSize() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ([(MTLPointerType*)m_ptr dataSize]);
#else
		return 0;
#endif
	}
	
	bool PointerType::GetElementIsArgumentBuffer() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ([(MTLPointerType*)m_ptr elementIsArgumentBuffer]);
#else
		return false;
#endif
	}
	
	StructType PointerType::GetElementStructType()
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return StructType([(MTLPointerType*)m_ptr elementStructType]);
#else
		return StructType();
#endif
	}
	
	ArrayType PointerType::GetElementArrayType()
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return ArrayType([(MTLArrayType*)m_ptr elementArrayType]);
#else
		return ArrayType();
#endif
	}
	
    StructMember::StructMember() :
        ns::Object<MTLStructMember*>([[MTLStructMember alloc] init], false)
    {
    }

    ns::String StructMember::GetName() const
    {
        Validate();
        return [(MTLStructMember*)m_ptr name];
    }

    NSUInteger StructMember::GetOffset() const
    {
        Validate();
        return NSUInteger([(MTLStructMember*)m_ptr offset]);
    }

    DataType StructMember::GetDataType() const
    {
        Validate();
        return DataType([(MTLStructMember*)m_ptr dataType]);
    }

    StructType StructMember::GetStructType() const
    {
        Validate();
        return [(MTLStructMember*)m_ptr structType];
    }

    ArrayType StructMember::GetArrayType() const
    {
        Validate();
        return [(MTLStructMember*)m_ptr arrayType];
    }

	TextureReferenceType StructMember::GetTextureReferenceType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLStructMember*)m_ptr textureReferenceType];
#else
		return TextureReferenceType();
#endif
	}
	
	PointerType StructMember::GetPointerType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLStructMember*)m_ptr pointerType];
#else
		return PointerType();
#endif
	}
	
	uint64_t StructMember::GetArgumentIndex() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLStructMember*)m_ptr argumentIndex];
#else
		return 0;
#endif
	}
	
    StructType::StructType() :
        ns::Object<MTLStructType*>([[MTLStructType alloc] init], false)
    {
    }

    const ns::Array<StructMember> StructType::GetMembers() const
    {
        Validate();
        return [(MTLStructType*)m_ptr members];
    }

    StructMember StructType::GetMember(const ns::String& name) const
    {
        Validate();
        return [(MTLStructType*)m_ptr memberByName:(NSString*)name.GetPtr()];
    }

    ArrayType::ArrayType() :
        ns::Object<MTLArrayType*>([[MTLArrayType alloc] init], false)
    {
    }

    NSUInteger ArrayType::GetArrayLength() const
    {
        Validate();
        return NSUInteger([(MTLArrayType*)m_ptr arrayLength]);
    }

    DataType ArrayType::GetElementType() const
    {
        Validate();
        return DataType([(MTLArrayType*)m_ptr elementType]);
    }

    NSUInteger ArrayType::GetStride() const
    {
        Validate();
        return NSUInteger([(MTLArrayType*)m_ptr stride]);
    }

    StructType ArrayType::GetElementStructType() const
    {
        Validate();
        return [(MTLArrayType*)m_ptr elementStructType];
    }

    ArrayType ArrayType::GetElementArrayType() const
    {
        Validate();
        return [(MTLArrayType*)m_ptr elementArrayType];
    }
	
	uint64_t ArrayType::GetArgumentIndexStride() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLArrayType*)m_ptr argumentIndexStride];
#else
		return 0;
#endif
	}
	
	TextureReferenceType ArrayType::GetElementTextureReferenceType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLArrayType*)m_ptr elementTextureReferenceType];
#else
		return TextureReferenceType();
#endif
	}
	
	PointerType ArrayType::GetElementPointerType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLArrayType*)m_ptr elementPointerType];
#else
		return PointerType();
#endif
	}

    Argument::Argument() :
        ns::Object<MTLArgument*>([[MTLArgument alloc] init], false)
    {
    }

    ns::String Argument::GetName() const
    {
        Validate();
        return [(MTLArgument*)m_ptr name];
    }

    ArgumentType Argument::GetType() const
    {
        Validate();
        return ArgumentType([(MTLArgument*)m_ptr type]);
    }

    ArgumentAccess Argument::GetAccess() const
    {
        Validate();
        return ArgumentAccess([(MTLArgument*)m_ptr access]);
    }

    NSUInteger Argument::GetIndex() const
    {
        Validate();
        return NSUInteger([(MTLArgument*)m_ptr index]);
    }

    bool Argument::IsActive() const
    {
        Validate();
        return [(MTLArgument*)m_ptr isActive];
    }

    NSUInteger Argument::GetBufferAlignment() const
    {
        Validate();
        return NSUInteger([(MTLArgument*)m_ptr bufferAlignment]);
    }

    NSUInteger Argument::GetBufferDataSize() const
    {
        Validate();
        return NSUInteger([(MTLArgument*)m_ptr bufferDataSize]);
    }

    DataType Argument::GetBufferDataType() const
    {
        Validate();
        return DataType([(MTLArgument*)m_ptr bufferDataType]);
    }

    StructType Argument::GetBufferStructType() const
    {
        Validate();
        return StructType([(MTLArgument*)m_ptr bufferStructType]);
    }
	
	PointerType	   Argument::GetBufferPointerType() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return [(MTLArgument*)m_ptr bufferPointerType];
#else
		return PointerType();
#endif
	}

    NSUInteger Argument::GetThreadgroupMemoryAlignment() const
    {
        Validate();
        return NSUInteger([(MTLArgument*)m_ptr threadgroupMemoryAlignment]);
    }

    NSUInteger Argument::GetThreadgroupMemoryDataSize() const
    {
        Validate();
        return NSUInteger([(MTLArgument*)m_ptr threadgroupMemoryDataSize]);
    }

    TextureType Argument::GetTextureType() const
    {
        Validate();
        return TextureType([(MTLArgument*)m_ptr textureType]);
    }

    DataType Argument::GetTextureDataType() const
    {
        Validate();
        return DataType([(MTLArgument*)m_ptr textureDataType]);
    }

    bool Argument::IsDepthTexture() const
    {
        Validate();
#if MTLPP_IS_AVAILABLE(10_12, 10_0)
        return [(MTLArgument*)m_ptr isDepthTexture];
#else
        return false;
#endif
    }
	
	NSUInteger       Argument::GetArrayLength() const
	{
		Validate();
#if MTLPP_IS_AVAILABLE(10_13, 11_0)
		return NSUInteger([(MTLArgument*)m_ptr arrayLength]);
#else
		return 0;
#endif
	}
}

MTLPP_END
