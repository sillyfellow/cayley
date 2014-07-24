// Copyright 2014 The Cayley Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

%%{
	machine quads;

	action Escape {
		isEscaped = true
	}

	action StartSubject {
		subject = p
	}

	action StartPredicate {
		predicate = p
	}

	action StartObject {
		object = p
	}

	action StartLabel {
		label = p
	}

	action SetSubject {
		if subject < 0 {
			panic("unexpected parser state: subject start not set")
		}
		triple.Subject = unEscape(data[subject:p], isEscaped)
		isEscaped = false
	}

	action SetPredicate {
		if predicate < 0 {
			panic("unexpected parser state: predicate start not set")
		}
		triple.Predicate = unEscape(data[predicate:p], isEscaped)
		isEscaped = false
	}

	action SetObject {
		if object < 0 {
			panic("unexpected parser state: object start not set")
		}
		triple.Object = unEscape(data[object:p], isEscaped)
		isEscaped = false
	}

	action SetLabel {
		if label < 0 {
			panic("unexpected parser state: label start not set")
		}
		triple.Provenance = unEscape(data[label:p], isEscaped)
		isEscaped = false
	}

	action Return {
		return triple, nil
	}

	action Comment {
	}

	action Error {
		if p < len(data) {
			return graph.Triple{}, fmt.Errorf("%v: unexpected rune %q at %d", ErrInvalid, data[p], p)
		}
		return graph.Triple{}, ErrIncomplete
	}
}%%
