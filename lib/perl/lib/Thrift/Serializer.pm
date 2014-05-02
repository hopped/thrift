#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#


#===============================================================================
# §package      Thrift::Serializer
# §state        public
#-------------------------------------------------------------------------------
# §description  Implementation of a Thrift serializer
#===============================================================================
package Thrift::Serializer;

require 5.6.0;

use strict;
use warnings;

use Thrift;
use Thrift::MemoryBuffer;
use Thrift::BinaryProtocol;

#===============================================================================
# §function     new
# §state        public
#-------------------------------------------------------------------------------
# §syntax       $Serializer = Thrift::Serializer->new();
# §syntax       $Serializer = Thrift::Serializer->new(Thrift::Protocol);
# §example      my $Serializer = Thrift::Serializer->new();
# §example      my $Factory = new Thrift::BinaryProtocolFactory;
#               my $Serializer = Thrift::Serializer->new();
#-------------------------------------------------------------------------------
# §description  Creates a new Thrift serializer based on the given protocol
#               factory. When no factory is given, the BinaryProtocolFactory is
#               used per default. Internally, the Thrift::MemoryBuffer is used
#               as transport.
#-------------------------------------------------------------------------------
# §input        $ProtocolFactory | a Thrift protocol factory | Thrift::Protocol
# §return       $Deserializer | Thrift deserializer | Thrift::Deserializer
#===============================================================================
sub new
{
    my $classname = shift;
    my $self = {
        factory   => shift // new Thrift::BinaryProtocolFactory,
        transport => new Thrift::MemoryBuffer,
    };
    $self->{protocol} = $self->{factory}->getProtocol($self->{transport});

    return bless($self, $classname);
}

#===============================================================================
# §function     serialize
# §state        public
#-------------------------------------------------------------------------------
# §syntax       my $ByteBuffer = $Serializer->serialize($PerlObject);
# §example      my $Object = ThriftTest::Xtruct->new();
#               my $Serializer = Thrift::Serializer->new();
#               my $Payload = $Serializer->serialize($Object);
#-------------------------------------------------------------------------------
# §description  Given the predefined Thrift protocol (BinaryProtocol per
#               default), this function serializes the given Thrift object
#               ($tbase) into a byte array.
#-------------------------------------------------------------------------------
# §input        $tbase | a Thrift object | e.g. ThriftTest::Xtruct
# §return       $bytebuffer | byte array representing $tbase | bytes
#===============================================================================
sub serialize
{
    my $self = shift;
    my ($tbase) = @_;

    $self->{transport}->resetBuffer();
    $tbase->write($self->{protocol});
    return $self->{transport}->getBuffer();
}

1;
