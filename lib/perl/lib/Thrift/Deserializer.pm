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
# §package      Thrift::Deserializer
# §state        public
#-------------------------------------------------------------------------------
# §description  Implementation of a Thrift deserializer
#===============================================================================
package Thrift::Deserializer;

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
# §syntax       $Deserializer = Thrift::Deserializer->new();
# §syntax       $Deserializer = Thrift::Deserializer->new(Thrift::Protocol);
# §example      my $Deserializer = Thrift::Deserializer->new();
# §example      my $Factory = new Thrift::BinaryProtocolFactory;
#               my $Deserializer = Thrift::Deserializer->new();
#-------------------------------------------------------------------------------
# §description  Creates a new Thrift deserializer based on the given protocol
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
# §function     deserialize
# §state        public
#-------------------------------------------------------------------------------
# §syntax       $Deserializer->deserialize($tbase, $payload);
# §example      my $Object = ThriftTest::Xtruct->new();
#               my $Deserializer = Thrift::Deserializer->new();
#               $Deserializer->deserialize($Object, $payload);
#-------------------------------------------------------------------------------
# §description  Given the predefined Thrift protocol (BinaryProtocol, per
#               default), this method deserializes the given bytes ($payload)
#               into the given Thrift object ($tbase).
#-------------------------------------------------------------------------------
# §input        $tbase | a Thrift object | e.g. ThriftTest::Xtruct
# §input        $payload | bytes representing a Thrift object | bytes
#===============================================================================
sub deserialize
{
    my $self = shift;
    my ($tbase, $payload) = @_;

    $self->{transport}->resetBuffer($payload);
    $tbase->read($self->{protocol});
}

1;
