/**
 * Copyright 2019 MilaGraph. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Zhaocheng Zhu, Shizhen Xu
 */

#pragma once

#include "core/optimizer.h"
#include "util/gpu.cuh"

namespace graphvite {

/**
 * @brief LINE model
 * @tparam _Vector vector type of embeddings
 *
 * Forward: dot(vertex, context)
 * Backward: gradient of forward function
 */
template<class _Vector>
class LINE {
public:
    static const size_t dim = _Vector::dim;
    typedef _Vector Vector;
    typedef typename _Vector::Float Float;

    __host__ __device__ static void forward(const Vector &vertex, const Vector &context, Float &output) {
        output = 0;
        FOR(i, dim)
            output += vertex[i] * context[i];
        output = SUM(output);
    }

    template<OptimizerType optimizer_type>
    __host__ __device__
    static void backward(Vector &vertex, Vector &context,
                         Float gradient, const Optimizer &optimizer, Float weight = 1) {
        auto update = get_update_function < Float, optimizer_type>();
        FOR(i, dim) {
            Float v = vertex[i];
            Float c = context[i];
            vertex[i] -= (optimizer.*update)(v, gradient * c, weight);
            context[i] -= (optimizer.*update)(c, gradient * v, weight);
        }
    }

    template<OptimizerType optimizer_type>
    __host__ __device__
    static void backward(Vector &vertex, Vector &context, Vector &vertex_moment1, Vector &context_moment1,
                         Float gradient, const Optimizer &optimizer, Float weight = 1) {
        auto update = get_update_function_1_moment < Float, optimizer_type>();
        FOR(i, dim) {
            Float v = vertex[i];
            Float c = context[i];
            vertex[i] -= (optimizer.*update)(v, gradient * c, vertex_moment1[i], weight);
            context[i] -= (optimizer.*update)(c, gradient * v, context_moment1[i], weight);
        }
    }

    template<OptimizerType optimizer_type>
    __host__ __device__
    static void backward(Vector &vertex, Vector &context, Vector &vertex_moment1, Vector &context_moment1,
                         Vector &vertex_moment2, Vector &context_moment2,
                         Float gradient, const Optimizer &optimizer, Float weight = 1) {
        auto update = get_update_function_2_moment < Float, optimizer_type>();
        FOR(i, dim) {
            Float v = vertex[i];
            Float c = context[i];
            vertex[i] -= (optimizer.*update)(v, gradient * c, vertex_moment1[i], vertex_moment2[i], weight);
            context[i] -= (optimizer.*update)(c, gradient * v, context_moment1[i], context_moment2[i], weight);
        }
    }
};

/**
 * @brief DeepWalk model
 * @tparam _Vector vector type of embeddings
 *
 * Forward: dot(vertex, context)
 * Backward: gradient of forward function
 */
template<class _Vector>
class DeepWalk : public LINE<_Vector> {};

/**
 * @brief node2vec model
 * @tparam _Vector vector type of embeddings
 *
 * Forward: dot(vertex, context)
 * Backward: gradient of forward function
 */
template<class _Vector>
class Node2Vec : public LINE<_Vector> {};

}